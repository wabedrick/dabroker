<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\InterestedBuyerResource;
use App\Models\PropertyFavorite;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class InterestedBuyerController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $user = $request->user();

        $query = PropertyFavorite::query()
            ->with(['property:id,public_id,title,status', 'user:id,name,preferred_role'])
            ->where('owner_id', $user->id)
            ->latest();

        if ($status = $request->string('status')->toString()) {
            $query->whereHas('property', fn($builder) => $builder->where('status', $status));
        }

        if ($propertyId = $request->string('property_id')->toString()) {
            $query->whereHas('property', fn($builder) => $builder->where('public_id', $propertyId));
        }

        if ($request->boolean('unread_only')) {
            $query->whereNull('owner_read_at');
        }

        $favorites = $query->paginate((int) $request->integer('per_page', 15));

        return InterestedBuyerResource::collection($favorites);
    }

    public function markRead(Request $request, PropertyFavorite $favorite): JsonResponse
    {
        abort_if($favorite->owner_id !== $request->user()->id, 403, 'You do not own this favorite.');

        if (is_null($favorite->owner_read_at)) {
            $favorite->forceFill(['owner_read_at' => now()])->save();
        }

        return response()->json([
            'message' => 'Favorite marked as reviewed.',
        ]);
    }
}
