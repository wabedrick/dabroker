<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Lodging;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class HostLodgingMediaController extends Controller
{
    public function store(Request $request, Lodging $lodging): JsonResponse
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $request->validate([
            'file' => ['required', 'file', 'image', 'max:10240'],
            'caption' => ['nullable', 'string', 'max:120'],
        ]);

        $media = $lodging
            ->addMediaFromRequest('file')
            ->usingFileName(Str::uuid() . '.' . $request->file('file')->getClientOriginalExtension())
            ->withCustomProperties([
                'caption' => $request->input('caption'),
            ])
            ->toMediaCollection('gallery');

        return response()->json([
            'message' => 'Media uploaded successfully.',
            'data' => $this->formatMedia($media),
        ], 201);
    }

    public function destroy(Lodging $lodging, string $media): JsonResponse
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $mediaItem = $lodging->media()->where('uuid', $media)->firstOrFail();
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
            'url' => $media->getUrl(),
            'thumbnail_url' => $media->getUrl('thumb'),
            'mime_type' => $media->mime_type,
            'size' => $media->size,
            'caption' => $media->getCustomProperty('caption'),
        ];
    }
}
