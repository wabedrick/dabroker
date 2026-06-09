<?php

namespace App\Services;

use App\Http\Resources\PropertyResource;
use App\Models\Property;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use Throwable;

class AiPropertySearchService
{
    private const MAX_CANDIDATES = 40;

    /**
     * @return array{paginator: LengthAwarePaginator, ai: array<string, mixed>}
     */
    public function search(Request $request, string $query, int $page, int $perPage, ?int $userId = null): array
    {
        $candidates = $this->candidateQuery($query, $userId)
            ->limit(self::MAX_CANDIDATES)
            ->get();

        if ($candidates->isEmpty()) {
            return [
                'paginator' => $this->paginateCollection(collect(), $page, $perPage),
                'ai' => [
                    'mode' => 'ai',
                    'summary' => 'No approved available properties matched this request.',
                    'fallback' => false,
                ],
            ];
        }

        if (! config('services.openai.api_key')) {
            return $this->fallback($query, $page, $perPage, $userId);
        }

        try {
            $ranking = $this->rankWithOpenAI($query, $candidates);
        } catch (Throwable) {
            return $this->fallback($query, $page, $perPage, $userId);
        }

        if ($ranking === null) {
            return $this->fallback($query, $page, $perPage, $userId);
        }

        $ranked = $this->applyRanking($candidates, $ranking['matches']);

        return [
            'paginator' => $this->paginateCollection($ranked, $page, $perPage),
            'ai' => [
                'mode' => 'ai',
                'summary' => $ranking['summary'] ?: 'Best AI-ranked property matches.',
                'fallback' => false,
            ],
        ];
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    public function buildCandidateSummaries(Collection $properties): array
    {
        return $properties
            ->map(fn(Property $property): array => [
                'id' => $property->public_id,
                'title' => $property->title,
                'type' => $property->type,
                'category' => $property->category,
                'price' => $property->price,
                'currency' => $property->currency,
                'size' => $property->size,
                'size_unit' => $property->size_unit,
                'city' => $property->city,
                'state' => $property->state,
                'country' => $property->country,
                'amenities' => $property->amenities ?? [],
                'nearby_places' => $property->nearby_places ?? [],
                'description' => Str::limit((string) $property->description, 500, ''),
            ])
            ->values()
            ->all();
    }

    private function candidateQuery(string $query, ?int $userId = null): Builder
    {
        $builder = Property::query()
            ->approved()
            ->where('is_available', true)
            ->with(['owner:id,name,preferred_role', 'media'])
            ->latest('published_at')
            ->latest('created_at');

        if ($userId) {
            $builder->withExists([
                'favoritedBy as is_favorited' => fn($query) => $query->where('user_id', $userId),
            ]);
        }

        $terms = $this->searchTerms($query);
        if ($terms !== []) {
            $builder->where(function (Builder $termBuilder) use ($terms): void {
                foreach ($terms as $term) {
                    $termBuilder->orWhere('title', 'like', "%{$term}%")
                        ->orWhere('description', 'like', "%{$term}%")
                        ->orWhere('city', 'like', "%{$term}%")
                        ->orWhere('state', 'like', "%{$term}%")
                        ->orWhere('country', 'like', "%{$term}%")
                        ->orWhere('address', 'like', "%{$term}%")
                        ->orWhere('type', 'like', "%{$term}%")
                        ->orWhere('category', 'like', "%{$term}%");
                }
            });
        }

        return $builder;
    }

    /**
     * @return array<int, string>
     */
    private function searchTerms(string $query): array
    {
        $stopWords = ['need', 'want', 'with', 'near', 'around', 'property', 'looking', 'for', 'the', 'and', 'a', 'an'];
        $words = preg_split('/[^a-z0-9]+/i', Str::lower($query)) ?: [];

        return array_values(array_unique(array_filter(
            $words,
            fn(string $word): bool => strlen($word) >= 3 && ! in_array($word, $stopWords, true)
        )));
    }

    /**
     * @param Collection<int, Property> $candidates
     * @return array{summary: string, matches: array<int, array<string, mixed>>}|null
     */
    private function rankWithOpenAI(string $query, Collection $candidates): ?array
    {
        $response = Http::withToken((string) config('services.openai.api_key'))
            ->acceptJson()
            ->timeout(30)
            ->post('https://api.openai.com/v1/responses', [
                'model' => config('services.openai.model', 'gpt-5.5'),
                'input' => [
                    [
                        'role' => 'system',
                        'content' => 'You are a real estate search agent. Rank only the provided property candidates. Return concise, honest match reasons. Do not invent facts.',
                    ],
                    [
                        'role' => 'user',
                        'content' => json_encode([
                            'query' => $query,
                            'properties' => $this->buildCandidateSummaries($candidates),
                        ]),
                    ],
                ],
                'text' => [
                    'format' => [
                        'type' => 'json_schema',
                        'name' => 'property_ai_search_results',
                        'strict' => true,
                        'schema' => [
                            'type' => 'object',
                            'additionalProperties' => false,
                            'required' => ['summary', 'matches'],
                            'properties' => [
                                'summary' => ['type' => 'string'],
                                'matches' => [
                                    'type' => 'array',
                                    'items' => [
                                        'type' => 'object',
                                        'additionalProperties' => false,
                                        'required' => ['id', 'score', 'reason', 'missing'],
                                        'properties' => [
                                            'id' => ['type' => 'string'],
                                            'score' => ['type' => 'integer', 'minimum' => 0, 'maximum' => 100],
                                            'reason' => ['type' => 'string'],
                                            'missing' => [
                                                'type' => 'array',
                                                'items' => ['type' => 'string'],
                                            ],
                                        ],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ]);

        if (! $response->successful()) {
            return null;
        }

        $decoded = json_decode($this->extractResponseText($response->json()), true);

        if (! is_array($decoded) || ! isset($decoded['matches']) || ! is_array($decoded['matches'])) {
            return null;
        }

        return [
            'summary' => is_string($decoded['summary'] ?? null) ? $decoded['summary'] : '',
            'matches' => $decoded['matches'],
        ];
    }

    private function extractResponseText(array $payload): string
    {
        if (isset($payload['output_text']) && is_string($payload['output_text'])) {
            return $payload['output_text'];
        }

        foreach (($payload['output'] ?? []) as $item) {
            foreach (($item['content'] ?? []) as $content) {
                if (isset($content['text']) && is_string($content['text'])) {
                    return $content['text'];
                }
            }
        }

        return '';
    }

    /**
     * @param Collection<int, Property> $candidates
     * @param array<int, array<string, mixed>> $matches
     * @return Collection<int, Property>
     */
    private function applyRanking(Collection $candidates, array $matches): Collection
    {
        $propertiesById = $candidates->keyBy('public_id');
        $used = [];
        $ranked = collect();

        foreach ($matches as $match) {
            $id = (string) ($match['id'] ?? '');
            $property = $propertiesById->get($id);

            if (! $property || isset($used[$id])) {
                continue;
            }

            $property->setAttribute('ai_match', [
                'score' => max(0, min(100, (int) ($match['score'] ?? 0))),
                'reason' => (string) ($match['reason'] ?? 'AI-ranked match.'),
                'missing' => array_values(array_filter((array) ($match['missing'] ?? []), 'is_string')),
            ]);

            $ranked->push($property);
            $used[$id] = true;
        }

        $candidates
            ->reject(fn(Property $property): bool => isset($used[$property->public_id]))
            ->each(function (Property $property) use ($ranked): void {
                $property->setAttribute('ai_match', [
                    'score' => 40,
                    'reason' => 'Near match from available approved listings.',
                    'missing' => [],
                ]);
                $ranked->push($property);
            });

        return $ranked;
    }

    /**
     * @return array{paginator: LengthAwarePaginator, ai: array<string, mixed>}
     */
    private function fallback(string $query, int $page, int $perPage, ?int $userId = null): array
    {
        $paginator = $this->candidateQuery($query, $userId)
            ->paginate($perPage, ['*'], 'page', $page);

        $paginator->getCollection()->loadMissing(['owner:id,name,preferred_role', 'media']);

        return [
            'paginator' => $paginator,
            'ai' => [
                'mode' => 'standard',
                'summary' => 'AI search is unavailable, so standard property search was used.',
                'fallback' => true,
            ],
        ];
    }

    /**
     * @param Collection<int, Property> $items
     */
    private function paginateCollection(Collection $items, int $page, int $perPage): LengthAwarePaginator
    {
        return new LengthAwarePaginator(
            $items->forPage($page, $perPage)->values(),
            $items->count(),
            $perPage,
            $page,
            ['path' => request()->url(), 'query' => request()->query()]
        );
    }
}
