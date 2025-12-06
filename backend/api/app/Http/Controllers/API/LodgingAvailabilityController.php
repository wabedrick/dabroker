<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Lodging;
use Carbon\Carbon;
use Illuminate\Http\Request;

class LodgingAvailabilityController extends Controller
{
    public function index(Request $request, Lodging $lodging)
    {
        $validated = $request->validate([
            'check_in' => 'required|date',
            'check_out' => 'required|date|after:check_in',
        ]);

        $checkIn = Carbon::parse($validated['check_in']);
        $checkOut = Carbon::parse($validated['check_out']);

        $bookedRooms = Booking::where('lodging_id', $lodging->id)
            ->where('status', '!=', 'cancelled')
            ->where(function ($query) use ($checkIn, $checkOut) {
                $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<=', $checkIn)
                            ->where('check_out', '>=', $checkOut);
                    });
            })
            ->sum('rooms_count');

        $totalRooms = $lodging->total_rooms ?? 0;
        $availableRooms = max(0, $totalRooms - $bookedRooms);

        return response()->json(['available_rooms' => (int) $availableRooms]);
    }
}
