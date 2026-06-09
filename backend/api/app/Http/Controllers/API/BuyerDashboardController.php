<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\BookingResource;
use App\Http\Resources\PropertyInquiryResource;
use App\Http\Resources\PropertyResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BuyerDashboardController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        // Get notification counters
        $notificationCounters = $this->buildNotificationCounters($user->id);

        // Get recent chats with property owners
        $recentChats = $user->sentPropertyInquiries()
            ->with(['property:id,public_id,title,status', 'owner:id,name,preferred_role'])
            ->latest()
            ->limit(5)
            ->get();

        // Get all bookings (both pending and confirmed)
        $bookings = $user->bookings()
            ->with(['lodging:id,public_id,title,price_per_night', 'lodging.host:id,name,preferred_role'])
            ->latest()
            ->get();

        // Get favorite properties
        $favoriteProperties = $user->favoriteProperties()
            ->with(['owner:id,name,preferred_role', 'media'])
            ->latest('property_favorites.created_at')
            ->limit(5)
            ->get();

        return response()->json([
            'data' => [
                'notifications' => $notificationCounters,
                'recent_chats' => PropertyInquiryResource::collection($recentChats),
                'bookings' => BookingResource::collection($bookings),
                'favorite_properties' => PropertyResource::collection($favoriteProperties),
            ],
        ]);
    }

    private function buildNotificationCounters(int $userId): array
    {
        // Unread chats from property owners (where user is the sender)
        $unreadChatsFromOwners = DB::table('property_inquiries')
            ->where('sender_id', $userId)
            ->whereNull('buyer_read_at')
            ->count();

        // Pending bookings
        $pendingBookings = DB::table('bookings')
            ->where('user_id', $userId)
            ->where('status', 'pending')
            ->count();

        // Confirmed bookings
        $confirmedBookings = DB::table('bookings')
            ->where('user_id', $userId)
            ->where('status', 'confirmed')
            ->count();

        // Total saved favorites
        $savedFavorites = DB::table('property_favorites')
            ->where('user_id', $userId)
            ->count();

        return [
            'unread_chats_from_owners' => $unreadChatsFromOwners,
            'pending_bookings' => $pendingBookings,
            'confirmed_bookings' => $confirmedBookings,
            'saved_favorites' => $savedFavorites,
            'total_bookings' => $pendingBookings + $confirmedBookings,
        ];
    }
}
