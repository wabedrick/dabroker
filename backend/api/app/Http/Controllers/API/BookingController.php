<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Lodging;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class BookingController extends Controller
{
    public function index()
    {
        $bookings = Auth::user()
            ->hasMany(Booking::class, 'user_id')
            ->with(['lodging', 'lodging.host.roles', 'lodging.host.permissions'])
            ->latest()
            ->paginate(20);

        return \App\Http\Resources\BookingResource::collection($bookings);
    }

    public function hostIndex()
    {
        $bookings = Booking::whereHas('lodging', function ($query) {
            $query->where('host_id', Auth::id());
        })
            ->with(['lodging', 'user.roles', 'user.permissions'])
            ->latest()
            ->paginate(20);

        return \App\Http\Resources\BookingResource::collection($bookings);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'lodging_id' => 'required|exists:lodgings,public_id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'guests_count' => 'required|integer|min:1',
            'rooms_count' => 'required|integer|min:1',
            'notes' => 'nullable|string',
        ]);

        $lodging = Lodging::with('host')->where('public_id', $validated['lodging_id'])->firstOrFail();

        // Check if lodging is approved
        // if ($lodging->status !== 'approved') {
        //     return response()->json(['message' => 'Lodging is not available for booking'], 400);
        // }

        // Check guests count (per room logic or total logic? Assuming max_guests is per room usually, but here it seems to be total for the listing.
        // If total_rooms > 1, max_guests might be per room. Let's assume max_guests is per room for now, or total capacity.
        // Let's assume max_guests is the capacity of a single unit/room type if we are talking about hotels.
        // If the user books N rooms, the capacity is N * max_guests.

        if ($validated['guests_count'] > ($lodging->max_guests * $validated['rooms_count'])) {
            return response()->json([
                'message' => "These rooms can accommodate maximum " . ($lodging->max_guests * $validated['rooms_count']) . " guests"
            ], 400);
        }

        $checkIn = Carbon::parse($validated['check_in']);
        $checkOut = Carbon::parse($validated['check_out']);

        // Check availability
        // Sum of rooms booked for overlapping dates
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

        $availableRooms = $lodging->total_rooms - $bookedRooms;

        if ($availableRooms < $validated['rooms_count']) {
            return response()->json([
                'message' => 'Not enough rooms available for selected dates. Available: ' . $availableRooms
            ], 400);
        }

        // Calculate total price
        $nights = $checkIn->diffInDays($checkOut);
        $totalPrice = $lodging->price_per_night * $nights * $validated['rooms_count'];

        $booking = Booking::create([
            'user_id' => Auth::id(),
            'lodging_id' => $lodging->id,
            'check_in' => $checkIn,
            'check_out' => $checkOut,
            'guests_count' => $validated['guests_count'],
            'rooms_count' => $validated['rooms_count'],
            'total_price' => $totalPrice,
            'status' => 'pending',
            'notes' => $validated['notes'] ?? null,
        ]);

        $booking->setRelation('lodging', $lodging);
        $booking->setRelation('user', Auth::user());

        // Notify the host
        if ($lodging->host) {
            try {
                $lodging->host->notify(new \App\Notifications\NewBookingNotification($booking));
            } catch (\Exception $e) {
                // Log error but don't fail the request
                \Illuminate\Support\Facades\Log::error('Failed to notify host: ' . $e->getMessage());
            }
        }

        return response()->json([
            'message' => 'Booking created successfully',
            'data' => new \App\Http\Resources\BookingResource($booking->load('lodging')),
        ], 201);
    }

    public function show(Booking $booking)
    {
        if ($booking->user_id !== Auth::id() && $booking->lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $booking->load(['lodging', 'user', 'lodging.host']);

        return response()->json(['data' => new \App\Http\Resources\BookingResource($booking)]);
    }

    public function update(Request $request, Booking $booking)
    {
        $validated = $request->validate([
            'status' => 'required|in:confirmed,cancelled,completed',
        ]);

        // Only host can confirm or complete
        if (in_array($validated['status'], ['confirmed', 'completed']) && $booking->lodging->host_id !== Auth::id()) {
            abort(403, 'Only the host can confirm or complete bookings');
        }

        // Cancel can be performed by the booking user OR the lodging host (as a rejection)
        if ($validated['status'] === 'cancelled' && $booking->user_id !== Auth::id() && $booking->lodging->host_id !== Auth::id()) {
            abort(403, 'Only the user or the lodging host can cancel/reject this booking');
        }

        $booking->status = $validated['status'];

        if ($validated['status'] === 'confirmed') {
            $booking->confirmed_at = now();
        }

        if ($validated['status'] === 'cancelled') {
            $booking->cancelled_at = now();
        }

        $booking->save();

        // Notify the user if status changed
        if ($booking->wasChanged('status')) {
            $booking->load(['lodging', 'user']);
            $booking->user->notify(new \App\Notifications\BookingStatusChangedNotification($booking));
        }

        return response()->json([
            'message' => 'Booking updated successfully',
            'data' => new \App\Http\Resources\BookingResource($booking),
        ]);
    }
}
