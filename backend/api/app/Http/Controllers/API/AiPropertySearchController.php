<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\PropertyResource;
use App\Services\AiPropertySearchService;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class AiPropertySearchController extends Controller
{
    public function __invoke(Request $request, AiPropertySearchService $service): AnonymousResourceCollection
    {
        $validated = $request->validate([
            'query' => ['required', 'string', 'min:2', 'max:500'],
            'page' => ['sometimes', 'integer', 'min:1'],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:50'],
        ]);

        $page = (int) ($validated['page'] ?? 1);
        $perPage = (int) ($validated['per_page'] ?? 15);

        $result = $service->search(
            $request,
            trim($validated['query']),
            $page,
            $perPage,
            $request->user()?->id
        );

        return PropertyResource::collection($result['paginator'])
            ->additional([
                'meta' => [
                    'ai' => $result['ai'],
                ],
            ]);
    }
}
