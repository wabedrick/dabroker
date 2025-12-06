<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\PropertyFavorite */
class InterestedBuyerResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'favorited_at' => $this->created_at,
            'owner_read_at' => $this->owner_read_at,
            'property' => [
                'id' => $this->property?->public_id,
                'title' => $this->property?->title ?? 'Unknown Property',
                'status' => $this->property?->status?->value,
            ],
            'buyer' => [
                'id' => $this->user?->id,
                'name' => $this->user?->name ?? 'Unknown User',
                'preferred_role' => $this->user?->preferred_role,
            ],
        ];
    }
}
