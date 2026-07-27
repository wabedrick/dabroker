<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Room;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OwnerPropertyRoomController extends Controller
{
    public function index(Request $request, Property $property): JsonResponse
    {
        $this->authorize('view', $property);
        // Only return rooms for this property
        return response()->json([
            'data' => $property->rooms()->latest()->get()
        ]);
    }

    public function store(Request $request, Property $property): JsonResponse
    {
        $this->authorize('update', $property);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'features' => 'nullable|array',
            'is_available' => 'boolean',
            'description' => 'nullable|string',
        ]);

        $room = $property->rooms()->create([
            ...$validated,
            'currency' => $validated['currency'] ?? 'USD',
            'is_available' => $validated['is_available'] ?? true,
        ]);

        return response()->json([
            'data' => $room
        ], 201);
    }

    public function update(Request $request, Property $property, Room $room): JsonResponse
    {
        $this->authorize('update', $property);

        if ($room->property_id !== $property->id) {
            abort(404);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric|min:0',
            'currency' => 'nullable|string|size:3',
            'features' => 'nullable|array',
            'is_available' => 'boolean',
            'description' => 'nullable|string',
        ]);

        $room->update($validated);

        return response()->json([
            'data' => $room->fresh()
        ]);
    }

    public function destroy(Request $request, Property $property, Room $room): JsonResponse
    {
        $this->authorize('update', $property);

        if ($room->property_id !== $property->id) {
            abort(404);
        }

        $room->delete();

        return response()->json([
            'message' => 'Room deleted successfully.'
        ]);
    }
}
