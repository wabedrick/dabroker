<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\PropertyResource;
use App\Models\Property;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PropertyBrowseController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $perPage = (int) $request->integer('per_page', 15);
        $perPage = max(1, min($perPage, 50));
        $userId = $request->user()?->id;

        if ($request->filled('q')) {
            $paginator = Property::search((string) $request->query('q'))
                ->query(function (Builder $builder) use ($request, $userId): void {
                    $this->applyFilters($builder, $request);
                    $this->applyFavoriteFlag($builder, $userId);
                })
                ->paginate($perPage);
        } else {
            $query = Property::query()->approved();
            $this->applyFilters($query, $request);
            $this->applyFavoriteFlag($query, $userId);
            $paginator = $query->with(['owner:id,name,preferred_role', 'media'])->paginate($perPage);
        }

        $paginator->getCollection()->loadMissing(['owner:id,name,preferred_role', 'media']);

        return PropertyResource::collection($paginator);
    }

    public function show(Request $request, Property $property): PropertyResource
    {
        abort_if($property->status !== PropertyStatus::Approved || ! $property->is_available, 404);

        if ($userId = $request->user()?->id) {
            $property->loadExists([
                'favoritedBy as is_favorited' => fn($query) => $query->where('user_id', $userId),
            ]);
        }

        return new PropertyResource(
            $property->loadMissing(['owner:id,name,preferred_role', 'media'])
        );
    }

    private function applyFilters(Builder $builder, Request $request): Builder
    {
        $builder->approved()->where('is_available', true);

        foreach (['type', 'category', 'city', 'state', 'country'] as $field) {
            if ($request->filled($field)) {
                $builder->where($field, $request->query($field));
            }
        }

        if ($request->filled('price_min')) {
            $builder->where('price', '>=', (float) $request->query('price_min'));
        }

        if ($request->filled('price_max')) {
            $builder->where('price', '<=', (float) $request->query('price_max'));
        }

        if ($request->filled('available_from')) {
            $builder->whereDate('available_from', '<=', $request->query('available_from'));
        }

        if ($request->filled('lat') && $request->filled('lng') && $request->filled('radius_km')) {
            $this->applyBoundingBoxFilter(
                $builder,
                (float) $request->query('lat'),
                (float) $request->query('lng'),
                (float) $request->query('radius_km')
            );
        }

        $sort = $request->query('sort', 'recent');

        match ($sort) {
            'price_asc' => $builder->orderBy('price', 'asc'),
            'price_desc' => $builder->orderBy('price', 'desc'),
            default => $builder->latest('published_at')->latest('created_at'),
        };

        return $builder;
    }

    private function applyFavoriteFlag(Builder $builder, ?int $userId = null): void
    {
        if (! $userId) {
            return;
        }

        $builder->withExists([
            'favoritedBy as is_favorited' => fn($query) => $query->where('user_id', $userId),
        ]);
    }

    private function applyBoundingBoxFilter(Builder $builder, float $lat, float $lng, float $radiusKm): void
    {
        $degreeRadius = $radiusKm / 111;

        $builder->whereBetween('latitude', [$lat - $degreeRadius, $lat + $degreeRadius])
            ->whereBetween('longitude', [$lng - $degreeRadius, $lng + $degreeRadius]);
    }
}
