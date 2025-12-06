<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HostBookingController extends Controller
{
    public function index()
    {
        $bookings = Booking::whereHas('lodging', function ($query) {
            $query->where('host_id', Auth::id());
        })
            ->with(['lodging', 'user', 'user.roles', 'user.permissions'])
            ->latest()
            ->paginate(20);

        return \App\Http\Resources\BookingResource::collection($bookings);
    }

    public function approve(Booking $booking)
    {
        if ($booking->lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        if ($booking->status !== 'pending') {
            return response()->json(['message' => 'Booking is not pending'], 400);
        }

        $booking->update([
            'status' => 'confirmed',
            'confirmed_at' => now(),
        ]);

        return new \App\Http\Resources\BookingResource($booking);
    }

    public function reject(Booking $booking)
    {
        if ($booking->lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        if ($booking->status !== 'pending') {
            return response()->json(['message' => 'Booking is not pending'], 400);
        }

        $booking->update([
            'status' => 'cancelled',
            'cancelled_at' => now(),
        ]);

        return new \App\Http\Resources\BookingResource($booking);
    }
}
