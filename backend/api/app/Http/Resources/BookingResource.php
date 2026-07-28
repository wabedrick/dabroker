<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Booking as BookingModel;
use Carbon\Carbon;

class BookingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        // Compute available rooms for the booking's date range (excluding cancelled bookings)
        $availableRooms = null;
        if ($this->lodging && $this->check_in && $this->check_out) {
            $checkIn = Carbon::parse($this->check_in);
            $checkOut = Carbon::parse($this->check_out);

            $bookedRoomsQuery = BookingModel::where('lodging_id', $this->lodging_id)
                ->where('status', '!=', 'cancelled');
            
            if ($this->lodging_room_id) {
                $bookedRoomsQuery->where('lodging_room_id', $this->lodging_room_id);
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

            $totalRooms = $this->lodgingRoom ? $this->lodgingRoom->quantity : ($this->lodging->total_rooms ?? 0);
            $availableRooms = max(0, $totalRooms - $bookedRooms);
        }

        return [
            'id' => (int) $this->id,
            'public_id' => $this->public_id,
            'user_id' => isset($this->user_id) ? (int) $this->user_id : null,
            'lodging_id' => isset($this->lodging_id) ? (int) $this->lodging_id : null,
            'lodging_room_id' => isset($this->lodging_room_id) ? (int) $this->lodging_room_id : null,
            'check_in' => $this->check_in?->toDateString(),
            'check_out' => $this->check_out?->toDateString(),
            'guests_count' => isset($this->guests_count) ? (int) $this->guests_count : null,
            'rooms_count' => isset($this->rooms_count) ? (int) $this->rooms_count : null,
            'total_price' => isset($this->total_price) ? (float) $this->total_price : null,
            'available_rooms' => isset($availableRooms) ? (int) $availableRooms : null,
            'status' => $this->status,
            'notes' => $this->notes,
            'lodging' => new LodgingResource($this->whenLoaded('lodging')),
            'lodging_room' => new LodgingRoomResource($this->whenLoaded('lodgingRoom')),
            'user' => new UserResource($this->whenLoaded('user')),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
