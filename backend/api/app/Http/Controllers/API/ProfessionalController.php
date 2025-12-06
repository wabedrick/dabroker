<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\ProfessionalProfile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Auth;

class ProfessionalController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $professionals = User::query()
            ->whereHas('professionalProfile', function ($query) {
                $query->where('verification_status', 'verified');
            })
            ->when($request->type, function ($query, $type) {
                $query->role($type);
            })
            ->with('professionalProfile')
            ->paginate(20);

        return UserResource::collection($professionals);
    }

    public function show(User $user): UserResource
    {
        if (! $user->professionalProfile) {
            abort(404, 'Professional profile not found.');
        }

        return new UserResource($user->load('professionalProfile'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'license_number' => 'required|string',
            'specialties' => 'nullable|array',
            'bio' => 'required|string',
            'hourly_rate' => 'required|numeric',
        ]);

        $profile = ProfessionalProfile::updateOrCreate(
            ['user_id' => Auth::id()],
            [
                'license_number' => $request->license_number,
                'specialties' => $request->specialties,
                'bio' => $request->bio,
                'hourly_rate' => $request->hourly_rate,
                'verification_status' => 'pending',
            ]
        );

        return response()->json(['message' => 'Application submitted successfully.', 'data' => $profile]);
    }
}
