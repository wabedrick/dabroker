<?php

namespace App\Http\Resources;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

/** @mixin \App\Models\Property */
class PropertyResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'title' => $this->title,
            'slug' => $this->slug,
            'type' => $this->type,
            'category' => $this->category,
            'status' => $this->status?->value,
            'is_available' => $this->is_available,
            'price' => $this->price,
            'currency' => $this->currency,
            'size' => $this->size,
            'size_unit' => $this->size_unit,
            'house_age' => $this->house_age,
            'address' => $this->address,
            'city' => $this->city,
            'state' => $this->state,
            'country' => $this->country,
            'postal_code' => $this->postal_code,
            'latitude' => $this->latitude,
            'longitude' => $this->longitude,
            'amenities' => $this->amenities ?? [],
            'metadata' => $this->metadata ?? [],
            'description' => $this->description,
            'published_at' => $this->published_at,
            'approved_at' => $this->approved_at,
            'approved_by' => $this->approved_by,
            'rejection_reason' => $this->rejection_reason,
            'available_from' => $this->available_from,
            'owner' => $this->formatUserSummary('owner'),
            'approver' => $this->formatUserSummary('approver'),
            'gallery' => $this->formatGallery(),
            'is_favorited' => $this->isFavorited($request),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'deleted_at' => $this->deleted_at,
        ];
    }

    private function isFavorited(Request $request): bool
    {
        $user = $request->user();

        if (! $user) {
            return false;
        }

        if ($this->resource instanceof Model && $this->resource->relationLoaded('pivot')) {
            $pivotTable = $this->resource->getRelation('pivot')->getTable();

            if ($pivotTable === 'property_favorites') {
                return true;
            }
        }

        if ($this->relationLoaded('favoritedBy')) {
            return $this->favoritedBy->contains('id', $user->id);
        }

        if ($this->resource instanceof Model) {
            $attributes = $this->resource->getAttributes();

            if (array_key_exists('is_favorited', $attributes)) {
                return (bool) $attributes['is_favorited'];
            }
        }

        return false;
    }

    private function formatUserSummary(string $relation): ?array
    {
        if (! $this->relationLoaded($relation) || ! $this->{$relation}) {
            return null;
        }

        return [
            'id' => $this->{$relation}->id,
            'name' => $this->{$relation}->name,
            'preferred_role' => $this->{$relation}->preferred_role,
        ];
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function formatGallery(): array
    {
        $mediaItems = $this->relationLoaded('media')
            ? $this->media->where('collection_name', 'gallery')
            : $this->getMedia('gallery');

        return $mediaItems
            ->map(fn(Media $media): array => [
                'id' => $media->uuid,
                'name' => $media->name,
                'caption' => $media->getCustomProperty('caption'),
                'url' => $media->getFullUrl(),
                'thumbnail_url' => $media->hasGeneratedConversion('thumb') ? $media->getFullUrl('thumb') : $media->getFullUrl(),
                'preview_url' => $media->hasGeneratedConversion('preview') ? $media->getFullUrl('preview') : $media->getFullUrl(),
                'responsive_images' => $media->responsive_images,
                'created_at' => $media->created_at,
            ])
            ->values()
            ->toArray();
    }
}
