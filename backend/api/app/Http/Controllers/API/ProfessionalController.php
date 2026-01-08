<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\ProfessionalProfile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

use App\Models\PropertyInquiry;
use App\Notifications\NewPropertyInquiryNotification;

class ProfessionalController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = User::query();

        // If a specific role is requested, filter by that role
        $role = $request->input('role') ?? $request->input('type');
        if ($role) {
            $query->role($role);
        } else {
            // Otherwise, return all professionals
            $query->whereHas('roles', function ($q) {
                $q->whereIn('name', ['broker', 'surveyor', 'lawyer', 'real_estate_agent']);
            });
        }

        $professionals = $query->with(['professionalProfile', 'roles.permissions', 'permissions'])
            ->withCount(['ratings as average_rating' => function ($query) {
                $query->select(DB::raw('coalesce(avg(rating),0)'));
            }])
            ->orderByDesc('average_rating')
            ->paginate(20);

        return UserResource::collection($professionals);
    }

    public function show(User $user): UserResource
    {
        if (! $user->professionalProfile) {
            abort(404, 'Professional profile not found.');
        }

        return new UserResource($user->load(['professionalProfile.portfolios', 'roles.permissions', 'permissions']));
    }

    public function contact(Request $request, User $user)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
        ]);

        // Check if an open inquiry already exists
        $inquiry = PropertyInquiry::where('owner_id', $user->id)
            ->where('sender_id', Auth::id())
            ->whereNull('property_id')
            ->where('status', '!=', PropertyInquiry::STATUS_CLOSED)
            ->first();

        if (! $inquiry) {
            $inquiry = PropertyInquiry::create([
                'owner_id' => $user->id,
                'sender_id' => Auth::id(),
                'property_id' => null,
                'status' => PropertyInquiry::STATUS_OPEN,
                'message' => $request->message,
                'contact_method' => 'in_app',
                'contact_value' => Auth::user()->email,
                'metadata' => ['type' => 'professional_inquiry'],
            ]);

            $user->notify(new NewPropertyInquiryNotification($inquiry));
        } else {
            // If inquiry exists, just add the message to the thread
            // We can use the PropertyInquiryMessageController logic or just create it here
            // For simplicity, let's assume the frontend will redirect to the chat screen
            // and send the message there if an inquiry exists.
            // But the initial contact usually sends a message.

            $inquiry->messages()->create([
                'sender_id' => Auth::id(),
                'message' => $request->message,
            ]);
        }

        return response()->json([
            'message' => 'Message sent successfully.',
            'data' => [
                'inquiry_id' => $inquiry->id,
                'public_id' => $inquiry->public_id,
            ]
        ]);
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

    public function update(Request $request)
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'avatar' => 'nullable|image|max:2048', // 2MB Max
            'license_number' => 'sometimes|string',
            'specialties' => 'nullable|array',
            'education' => 'nullable|array',
            'certifications' => 'nullable|array',
            'languages' => 'nullable|array',
            'social_links' => 'nullable|array',
            'experience_years' => 'nullable|integer|min:0',
            'bio' => 'sometimes|string',
            'hourly_rate' => 'sometimes|numeric',
            'is_available' => 'sometimes|boolean',
        ]);

        /** @var \App\Models\User $user */
        $user = Auth::user();
        $profile = $user->professionalProfile;

        if (! $profile) {
            return response()->json(['message' => 'Professional profile not found.'], 404);
        }

        // Update User fields
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('phone')) {
            $user->phone = $request->phone;
        }
        if ($request->hasFile('avatar')) {
            $user->clearMediaCollection('avatar');
            $user->addMediaFromRequest('avatar')->toMediaCollection('avatar');
        }
        if ($user->isDirty()) {
            $user->save();
        }

        // Update Professional Profile fields
        $data = $request->only([
            'license_number',
            'specialties',
            'education',
            'certifications',
            'languages',
            'social_links',
            'experience_years',
            'bio',
            'hourly_rate',
            'is_available'
        ]);
        $profile->update($data);

        return response()->json(['message' => 'Profile updated successfully.', 'data' => $profile]);
    }
}
