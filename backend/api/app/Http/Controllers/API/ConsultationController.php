<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Consultation;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ConsultationController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        
        $consultations = Consultation::query()
            ->where('user_id', $user->id)
            ->orWhere('professional_id', $user->id)
            ->with(['user', 'professional'])
            ->latest()
            ->paginate(20);

        return response()->json($consultations);
    }

    public function store(Request $request)
    {
        $request->validate([
            'professional_id' => 'required|exists:users,id',
            'scheduled_at' => 'required|date|after:now',
            'notes' => 'nullable|string',
        ]);

        $professional = User::findOrFail($request->professional_id);

        // Ensure the target is actually a professional (has a profile)
        if (! $professional->professionalProfile) {
            abort(400, 'User is not a professional.');
        }

        $consultation = Consultation::create([
            'user_id' => Auth::id(),
            'professional_id' => $professional->id,
            'scheduled_at' => $request->scheduled_at,
            'notes' => $request->notes,
            'status' => 'pending',
        ]);

        return response()->json(['message' => 'Consultation requested.', 'data' => $consultation], 201);
    }

    public function update(Request $request, Consultation $consultation)
    {
        // Only the professional can accept/reject/complete
        if ($consultation->professional_id !== Auth::id()) {
            abort(403, 'Unauthorized.');
        }

        $request->validate([
            'status' => 'required|in:confirmed,rejected,completed,cancelled',
        ]);

        $consultation->update(['status' => $request->status]);

        return response()->json(['message' => 'Consultation updated.', 'data' => $consultation]);
    }
}
