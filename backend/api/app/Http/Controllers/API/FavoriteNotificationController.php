<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FavoriteNotificationController extends Controller
{
    public function acknowledge(Request $request): JsonResponse
    {
        DB::table('property_favorites')
            ->where('owner_id', $request->user()->id)
            ->whereNull('owner_read_at')
            ->update(['owner_read_at' => now()]);

        return response()->json([
            'message' => 'Favorite alerts cleared.',
        ]);
    }
}
