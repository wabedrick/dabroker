<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\PropertyResource;
use App\Models\Property;
use App\Models\PropertyFavorite;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Str;

class FavoritePropertyController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $favorites = $request->user()
            ->favoriteProperties()
            ->with(['owner:id,name,preferred_role', 'media'])
            ->latest('property_favorites.created_at')
            ->paginate((int) $request->integer('per_page', 15));

        return PropertyResource::collection($favorites);
    }

    public function store(Request $request, Property $property): JsonResponse
    {
        $this->authorizeFavorite($property);

        $favorite = PropertyFavorite::firstOrCreate(
            [
                'user_id' => $request->user()->id,
                'property_id' => $property->id,
            ],
            [
                'public_id' => (string) Str::uuid(),
                'owner_id' => $property->owner_id,
            ],
        );

        $favorite->forceFill(['owner_read_at' => null])->save();

        return response()->json([
            'message' => 'Property saved to favorites.',
        ], 201);
    }

    public function destroy(Request $request, Property $property): JsonResponse
    {
        $request->user()
            ->favoriteProperties()
            ->detach($property->id);

        return response()->json([
            'message' => 'Property removed from favorites.',
        ]);
    }

    private function authorizeFavorite(Property $property): void
    {
        abort_if($property->status !== PropertyStatus::Approved, 422, 'Only approved properties can be favorited.');
    }
}
