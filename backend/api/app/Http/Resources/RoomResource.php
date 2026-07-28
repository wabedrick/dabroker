<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

use Spatie\MediaLibrary\MediaCollections\Models\Media;

class RoomResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'name' => $this->name,
            'price' => $this->price,
            'currency' => $this->currency,
            'features' => $this->features ?? [],
            'is_available' => $this->is_available,
            'description' => $this->description,
            'capacity' => $this->capacity,
            'quantity' => $this->quantity,
            'room_type' => $this->room_type,
            'bed_type' => $this->bed_type,
            'gallery' => $this->formatGallery(),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
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
