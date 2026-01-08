<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LodgingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'host_id' => $this->host_id,
            'title' => $this->title,
            'slug' => $this->slug,
            'type' => $this->type,
            'status' => $this->status,
            'is_available' => $this->is_available,
            'price_per_night' => $this->price_per_night,
            'currency' => $this->currency,
            'max_guests' => $this->max_guests,
            'total_rooms' => $this->total_rooms,
            'description' => $this->description,
            'address' => $this->address,
            'city' => $this->city,
            'state' => $this->state,
            'country' => $this->country,
            'postal_code' => $this->postal_code,
            'latitude' => $this->latitude,
            'longitude' => $this->longitude,
            'amenities' => $this->amenities,
            'rules' => $this->rules,
            'published_at' => $this->published_at,
            'approved_at' => $this->approved_at,
            'host' => new UserResource($this->whenLoaded('host')),
            'approver' => new UserResource($this->whenLoaded('approver')),
            'media' => $this->whenLoaded('media', function () {
                return $this->getMedia('gallery')->map(function ($media) {
                    return [
                        'id' => $media->id,
                        'url' => $media->getFullUrl(),
                        'thumb_url' => $media->hasGeneratedConversion('thumb') ? $media->getFullUrl('thumb') : $media->getFullUrl(),
                        'preview_url' => $media->hasGeneratedConversion('preview') ? $media->getFullUrl('preview') : $media->getFullUrl(),
                    ];
                });
            }),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'average_rating' => $this->averageRating(),
            'ratings_count' => $this->ratingsCount(),
            'distance' => $this->when(isset($this->distance), function () {
                return round($this->distance, 1);
            }),
        ];
    }
}
