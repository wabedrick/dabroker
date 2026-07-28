<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Room;
use App\Http\Resources\RoomResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class OwnerPropertyRoomMediaController extends Controller
{
    public function store(Request $request, Property $property, Room $room)
    {
        $this->authorize('update', $property);

        if ($room->property_id !== $property->id) {
            abort(404);
        }

        $request->validate([
            'file' => 'required|file|mimes:jpg,jpeg,png,webp|max:10240',
            'caption' => 'nullable|string|max:255',
        ]);

        try {
            $media = $room
                ->addMediaFromRequest('file')
                ->usingFileName(Str::uuid() . '.' . $request->file('file')->getClientOriginalExtension())
                ->withCustomProperties([
                    'caption' => $request->input('caption'),
                ])
                ->toMediaCollection('gallery');

            return response()->json([
                'message' => 'Media uploaded successfully',
                'media' => [
                    'id' => $media->uuid,
                    'url' => $media->getFullUrl(),
                    'caption' => $media->getCustomProperty('caption'),
                ]
            ], 201);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Upload failed: ' . $e->getMessage()
            ], 500);
        }
    }

    public function destroy(Property $property, Room $room, Media $media): JsonResponse
    {
        $this->authorize('update', $property);

        if ($room->property_id !== $property->id) {
            abort(404);
        }

        if ($media->model_id !== $room->id || $media->model_type !== Room::class) {
            abort(404);
        }

        $media->delete();

        return response()->json([
            'message' => 'Media deleted successfully'
        ]);
    }
}
