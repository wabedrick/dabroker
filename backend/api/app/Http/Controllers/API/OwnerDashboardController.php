<?php

namespace App\Http\Controllers\API;

use App\Enums\PropertyStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\InterestedBuyerResource;
use App\Http\Resources\PropertyInquiryResource;
use App\Models\PropertyFavorite;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OwnerDashboardController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        $counts = $this->buildPropertyCounts($user);
        $notificationCounters = $this->buildNotificationCounters($user->id);

        $recentInquiries = $user->receivedPropertyInquiries()
            ->with(['property:id,public_id,title,status', 'sender:id,name,preferred_role'])
            ->latest()
            ->limit(3)
            ->get();

        $recentFavorites = PropertyFavorite::query()
            ->with(['property:id,public_id,title,status', 'user:id,name,preferred_role'])
            ->where('owner_id', $user->id)
            ->latest()
            ->limit(3)
            ->get();

        return response()->json([
            'data' => [
                'counts' => $counts,
                'notifications' => $notificationCounters,
                'recent_inquiries' => PropertyInquiryResource::collection($recentInquiries),
                'recent_interested_buyers' => InterestedBuyerResource::collection($recentFavorites),
            ],
        ]);
    }

    private function buildPropertyCounts($user): array
    {
        $statuses = [
            'total' => null,
            PropertyStatus::Pending->value => PropertyStatus::Pending,
            PropertyStatus::Approved->value => PropertyStatus::Approved,
            PropertyStatus::Rejected->value => PropertyStatus::Rejected,
        ];

        $counts = [
            'total' => $user->properties()->count(),
            'pending' => $user->properties()->where('status', PropertyStatus::Pending)->count(),
            'approved' => $user->properties()->where('status', PropertyStatus::Approved)->count(),
            'rejected' => $user->properties()->where('status', PropertyStatus::Rejected)->count(),
        ];

        return $counts;
    }

    private function buildNotificationCounters(int $ownerId): array
    {
        $unreadInquiries = DB::table('property_inquiries')
            ->where('owner_id', $ownerId)
            ->whereNull('read_at')
            ->count();

        $buyerUnreadInquiries = DB::table('property_inquiries')
            ->where('sender_id', $ownerId)
            ->whereNull('buyer_read_at')
            ->count();

        $unreadFavorites = DB::table('property_favorites')
            ->where('owner_id', $ownerId)
            ->whereNull('owner_read_at')
            ->count();

        $savedFavorites = DB::table('property_favorites')
            ->where('user_id', $ownerId)
            ->count();

        return [
            'unread_inquiries' => $unreadInquiries,
            'buyer_unread_inquiries' => $buyerUnreadInquiries,
            'unread_favorites' => $unreadFavorites,
            'saved_favorites' => $savedFavorites,
        ];
    }
}
