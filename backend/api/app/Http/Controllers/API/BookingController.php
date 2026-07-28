<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Lodging;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BookingController extends Controller
{
    public function index(Request $request)
    {
        $bookings = $request->user()
            ->bookings()
            ->with(['lodging', 'lodgingRoom', 'lodging.host.roles', 'lodging.host.permissions'])
            ->latest()
            ->paginate(20);

        return \App\Http\Resources\BookingResource::collection($bookings);
    }

    public function hostIndex()
    {
        $bookings = Booking::whereHas('lodging', function ($query) {
            $query->where('host_id', Auth::id());
        })
            ->with(['lodging', 'lodgingRoom', 'user.roles', 'user.permissions'])
            ->latest()
            ->paginate(20);

        return \App\Http\Resources\BookingResource::collection($bookings);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'lodging_id' => 'required|exists:lodgings,public_id',
            'lodging_room_id' => 'nullable|exists:lodging_rooms,public_id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'guests_count' => 'required|integer|min:1',
            'rooms_count' => 'required|integer|min:1',
            'notes' => 'nullable|string',
        ]);

        $lodging = Lodging::with('host')->where('public_id', $validated['lodging_id'])->firstOrFail();
        $lodgingRoom = null;
        if (!empty($validated['lodging_room_id'])) {
            $lodgingRoom = \App\Models\LodgingRoom::where('public_id', $validated['lodging_room_id'])
                ->where('lodging_id', $lodging->id)
                ->firstOrFail();
        }

        $maxGuests = $lodgingRoom ? $lodgingRoom->capacity : $lodging->max_guests;
        if ($maxGuests && $validated['guests_count'] > ($maxGuests * $validated['rooms_count'])) {
            return response()->json([
                'message' => "These rooms can accommodate maximum " . ($maxGuests * $validated['rooms_count']) . " guests"
            ], 400);
        }

        $checkIn = Carbon::parse($validated['check_in']);
        $checkOut = Carbon::parse($validated['check_out']);

        $bookedRoomsQuery = Booking::where('lodging_id', $lodging->id)
            ->where('status', 'confirmed');
            
        if ($lodgingRoom) {
            $bookedRoomsQuery->where('lodging_room_id', $lodgingRoom->id);
        } else {
            $bookedRoomsQuery->whereNull('lodging_room_id');
        }

        $bookedRooms = $bookedRoomsQuery->where(function ($query) use ($checkIn, $checkOut) {
                $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<=', $checkIn)
                            ->where('check_out', '>=', $checkOut);
                    });
            })
            ->sum('rooms_count');

        $totalRooms = $lodgingRoom ? $lodgingRoom->quantity : $lodging->total_rooms;
        $availableRooms = $totalRooms - $bookedRooms;

        if ($availableRooms < $validated['rooms_count']) {
            return response()->json([
                'message' => 'Not enough rooms available for selected dates. Available: ' . $availableRooms
            ], 400);
        }

        // Calculate total price
        $nights = $checkIn->diffInDays($checkOut);
        $pricePerNight = $lodgingRoom ? $lodgingRoom->price : $lodging->price_per_night;
        $totalPrice = $pricePerNight * $nights * $validated['rooms_count'];

        $booking = Booking::create([
            'user_id' => Auth::id(),
            'lodging_id' => $lodging->id,
            'lodging_room_id' => $lodgingRoom?->id,
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
