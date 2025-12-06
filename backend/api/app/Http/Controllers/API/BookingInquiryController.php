<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\PropertyInquiry;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class BookingInquiryController extends Controller
{
    public function show(Request $request, Booking $booking): JsonResponse
    {
        $user = $request->user();
        $booking->load('lodging');

        // Authorization: User must be the guest or the host
        if ($user->id !== $booking->user_id && $user->id !== $booking->lodging->host_id) {
            abort(403, 'You do not have access to this booking inquiry.');
        }

        // Find existing inquiry
        $inquiry = PropertyInquiry::where('booking_id', $booking->id)->first();

        if (!$inquiry) {
            $inquiry = PropertyInquiry::create([
                'public_id' => (string) Str::uuid(),
                'property_id' => null,
                'booking_id' => $booking->id,
                'owner_id' => $booking->lodging->host_id, // Host
                'sender_id' => $booking->user_id, // Guest
                'status' => PropertyInquiry::STATUS_OPEN,
                'contact_method' => 'app',
                'contact_value' => 'chat',
                'message' => 'Chat started',
                'buyer_read_at' => now(),
                'responded_at' => now(),
            ]);
        }

        // Load messages and related data
        $inquiry->load(['messages.sender', 'booking.lodging', 'booking.user']);

        return response()->json([
            'data' => $inquiry
        ]);
    }
}
