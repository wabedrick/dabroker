<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\LodgingRoomResource;
use App\Models\Lodging;
use App\Models\LodgingRoom;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HostLodgingRoomController extends Controller
{
    public function index(Lodging $lodging)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $rooms = $lodging->rooms()->with('media')->latest()->get();

        return LodgingRoomResource::collection($rooms);
    }

    public function store(Request $request, Lodging $lodging)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'capacity' => 'nullable|integer|min:1',
            'quantity' => 'nullable|integer|min:1',
            'room_type' => 'nullable|string|max:100',
            'bed_type' => 'nullable|string|max:100',
            'features' => 'nullable|array',
            'description' => 'nullable|string',
            'is_available' => 'nullable|boolean',
        ]);

        $validated['currency'] = $validated['currency'] ?? 'USD';
        
        $room = $lodging->rooms()->create($validated);

        return new LodgingRoomResource($room->fresh());
    }

    public function update(Request $request, Lodging $lodging, LodgingRoom $room)
    {
        if ($lodging->host_id !== Auth::id() || $room->lodging_id !== $lodging->id) {
            abort(403, 'Unauthorized');
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'capacity' => 'nullable|integer|min:1',
            'quantity' => 'nullable|integer|min:1',
            'room_type' => 'nullable|string|max:100',
            'bed_type' => 'nullable|string|max:100',
            'features' => 'nullable|array',
            'description' => 'nullable|string',
            'is_available' => 'sometimes|boolean',
        ]);

        $room->update($validated);

        return new LodgingRoomResource($room->fresh());
    }

    public function destroy(Lodging $lodging, LodgingRoom $room)
    {
        if ($lodging->host_id !== Auth::id() || $room->lodging_id !== $lodging->id) {
            abort(403, 'Unauthorized');
        }

        $room->delete();

        return response()->json(['message' => 'Room deleted successfully']);
    }
}
