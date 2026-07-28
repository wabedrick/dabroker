<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Lodging;
use App\Models\LodgingRoom;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HostLodgingRoomMediaController extends Controller
{
    public function store(Request $request, Lodging $lodging, LodgingRoom $room)
    {
        if ($lodging->host_id !== Auth::id() || $room->lodging_id !== $lodging->id) {
            abort(403, 'Unauthorized');
        }

        $request->validate([
            'file' => 'required|file|image|max:10240',
            'caption' => 'nullable|string|max:255',
        ]);

        $media = $room->addMediaFromRequest('file')
            ->withCustomProperties(['caption' => $request->input('caption')])
            ->toMediaCollection('gallery');

        return response()->json([
            'message' => 'Media uploaded successfully',
            'media' => [
                'id' => $media->uuid,
                'url' => $media->getFullUrl(),
                'caption' => $media->getCustomProperty('caption'),
            ]
        ]);
    }

    public function destroy(Lodging $lodging, LodgingRoom $room, string $mediaId)
    {
        if ($lodging->host_id !== Auth::id() || $room->lodging_id !== $lodging->id) {
            abort(403, 'Unauthorized');
        }

        $media = $room->media()->where('uuid', $mediaId)->firstOrFail();
        $media->delete();

        return response()->json(['message' => 'Media deleted successfully']);
    }
}
