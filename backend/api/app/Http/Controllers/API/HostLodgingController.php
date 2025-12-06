<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\LodgingResource;
use App\Models\Lodging;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HostLodgingController extends Controller
{
    public function index()
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();

        $lodgings = $user
            ->lodgings()
            ->with(['media', 'host.roles', 'host.permissions'])
            ->latest()
            ->paginate(20);

        return LodgingResource::collection($lodgings);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type' => 'required|string|in:hotel,guest_house,lodge,apartment,resort,hostel,villa,cabin',
            'price_per_night' => 'required|numeric|min:0',
            'currency' => 'required|string|size:3',
            'max_guests' => 'required|integer|min:1',
            'total_rooms' => 'required|integer|min:1',
            'description' => 'required|string',
            'address' => 'nullable|string',
            'city' => 'required|string',
            'state' => 'nullable|string',
            'country' => 'required|string',
            'postal_code' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'amenities' => 'nullable|array',
            'rules' => 'nullable|array',
        ]);

        $validated['host_id'] = Auth::id();
        $validated['status'] = 'pending';

        $lodging = Lodging::create($validated);

        return new LodgingResource($lodging);
    }

    public function update(Request $request, Lodging $lodging)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'type' => 'sometimes|string|in:hotel,guest_house,lodge,apartment,resort,hostel,villa,cabin',
            'price_per_night' => 'sometimes|numeric|min:0',
            'currency' => 'sometimes|string|size:3',
            'max_guests' => 'sometimes|integer|min:1',
            'total_rooms' => 'sometimes|integer|min:1',
            'description' => 'sometimes|string',
            'address' => 'nullable|string',
            'city' => 'sometimes|string',
            'state' => 'nullable|string',
            'country' => 'sometimes|string',
            'postal_code' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'amenities' => 'nullable|array',
            'rules' => 'nullable|array',
            'is_available' => 'sometimes|boolean',
        ]);

        $lodging->update($validated);

        return new LodgingResource($lodging->fresh());
    }

    public function destroy(Lodging $lodging)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $lodging->delete();

        return response()->json(['message' => 'Lodging deleted successfully']);
    }
}
