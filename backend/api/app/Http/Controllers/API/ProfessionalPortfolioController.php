<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ProfessionalPortfolio;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfessionalPortfolioController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        if (!$user->professionalProfile) {
            return response()->json(['message' => 'Professional profile not found.'], 404);
        }

        return response()->json($user->professionalProfile->portfolios()->with('media')->get());
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'project_date' => 'nullable|date',
            'url' => 'nullable|url',
            'images.*' => 'image|max:5120', // 5MB max per image
        ]);

        $user = Auth::user();
        if (!$user->professionalProfile) {
            return response()->json(['message' => 'Professional profile not found.'], 404);
        }

        $portfolio = $user->professionalProfile->portfolios()->create($request->only([
            'title',
            'description',
            'project_date',
            'url'
        ]));

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $portfolio->addMedia($image)->toMediaCollection('portfolio_images');
            }
        }

        return response()->json(['message' => 'Portfolio item created successfully.', 'data' => $portfolio->load('media')], 201);
    }

    public function update(Request $request, $id)
    {
        $user = Auth::user();
        if (!$user->professionalProfile) {
            return response()->json(['message' => 'Professional profile not found.'], 404);
        }

        $portfolio = $user->professionalProfile->portfolios()->findOrFail($id);

        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'project_date' => 'nullable|date',
            'url' => 'nullable|url',
            'images.*' => 'image|max:5120',
        ]);

        $portfolio->update($request->only(['title', 'description', 'project_date', 'url']));

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $portfolio->addMedia($image)->toMediaCollection('portfolio_images');
            }
        }

        if ($request->has('delete_images')) {
            $portfolio->media()->whereIn('id', $request->delete_images)->delete();
        }

        return response()->json(['message' => 'Portfolio item updated successfully.', 'data' => $portfolio->load('media')]);
    }

    public function destroy($id)
    {
        $user = Auth::user();
        if (!$user->professionalProfile) {
            return response()->json(['message' => 'Professional profile not found.'], 404);
        }

        $portfolio = $user->professionalProfile->portfolios()->findOrFail($id);
        $portfolio->delete();

        return response()->json(['message' => 'Portfolio item deleted successfully.']);
    }
}
