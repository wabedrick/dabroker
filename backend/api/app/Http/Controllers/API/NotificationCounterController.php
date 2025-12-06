<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class NotificationCounterController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        $unreadInquiries = $user->receivedPropertyInquiries()
            ->whereNull('read_at')
            ->count();

        $buyerUnreadInquiries = $user->sentPropertyInquiries()
            ->whereNull('buyer_read_at')
            ->count();

        $unreadFavorites = DB::table('property_favorites')
            ->where('owner_id', $user->id)
            ->whereNull('owner_read_at')
            ->count();

        $savedFavorites = $user->favoriteProperties()->count();

        $pendingReservations = \App\Models\Booking::whereHas('lodging', function ($q) use ($user) {
            $q->where('host_id', $user->id);
        })->where('status', 'pending')->count();

        $confirmedBookings = \App\Models\Booking::where('user_id', $user->id)
            ->where('status', 'confirmed')
            ->where('check_out', '>=', now())
            ->count();

        return response()->json([
            'data' => [
                'unread_inquiries' => $unreadInquiries,
                'buyer_unread_inquiries' => $buyerUnreadInquiries,
                'unread_favorites' => $unreadFavorites,
                'saved_favorites' => $savedFavorites,
                'pending_reservations' => $pendingReservations,
                'confirmed_bookings' => $confirmedBookings,
            ],
        ]);
    }
}
