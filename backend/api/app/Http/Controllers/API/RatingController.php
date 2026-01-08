<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\RatingResource;
use App\Models\Lodging;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RatingController extends Controller
{
    public function index(Request $request)
    {
        $request->validate([
            'rateable_type' => 'required|string|in:user,lodging',
            'rateable_id' => 'required',
        ]);

        if ($request->rateable_type === 'user') {
            $model = User::findOrFail($request->rateable_id);
        } else {
            $model = Lodging::where('public_id', $request->rateable_id)->firstOrFail();
        }

        $reviews = $model->ratings()
            ->with(['user.roles.permissions', 'user.permissions'])
            ->latest()
            ->paginate(10);

        return RatingResource::collection($reviews);
    }

    public function store(Request $request)
    {
        $request->validate([
            'rateable_type' => 'required|string|in:user,lodging',
            'rateable_id' => 'required',
            'rating' => 'required|integer|min:1|max:5',
            'review' => 'nullable|string|max:1000',
        ]);

        if ($request->rateable_type === 'user') {
            $model = User::findOrFail($request->rateable_id);
        } else {
            $model = Lodging::where('public_id', $request->rateable_id)->firstOrFail();
        }
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $rating = $model->ratings()->updateOrCreate(
            ['user_id' => $user->id],
            [
                'rating' => $request->rating,
                'review' => $request->review,
            ]
        );

        return response()->json([
            'message' => 'Rating submitted successfully.',
            'data' => $rating,
        ]);
    }
}
