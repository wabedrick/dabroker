<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Property\UploadPropertyMediaRequest;
use App\Models\Property;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class OwnerPropertyMediaController extends Controller
{
    public function store(UploadPropertyMediaRequest $request, Property $property): JsonResponse
    {
        $this->authorize('update', $property);

        try {
            $media = $property
                ->addMediaFromRequest('file')
                ->usingFileName(Str::uuid() . '.' . $request->file('file')->getClientOriginalExtension())
                ->withCustomProperties([
                    'caption' => $request->input('caption'),
                ])
                ->toMediaCollection('gallery');

            return response()->json([
                'message' => 'Media uploaded successfully. Conversions queued.',
                'data' => $this->formatMedia($media),
            ], 201);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Upload failed: ' . $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ], 500);
        }
    }

    public function destroy(Property $property, string $media): JsonResponse
    {
        $this->authorize('update', $property);

        $mediaItem = $property->media()->where('uuid', $media)->firstOrFail();
        $mediaItem->delete();

        return response()->json([
            'message' => 'Media removed from gallery.',
        ]);
    }

    /**
     * @return array<string, mixed>
     */
    private function formatMedia(Media $media): array
    {
        return [
            'id' => $media->uuid,
            'name' => $media->name,
            'caption' => $media->getCustomProperty('caption'),
            'url' => $media->getFullUrl(),
            'thumbnail_url' => $media->getFullUrl(),
        ];
    }
}
