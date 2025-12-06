<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Lodging;
use App\Models\LodgingAvailability;
use Carbon\CarbonPeriod;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HostLodgingAvailabilityController extends Controller
{
    public function index(Lodging $lodging, Request $request)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $startDate = $request->input('start_date', now()->format('Y-m-d'));
        $endDate = $request->input('end_date', now()->addMonths(3)->format('Y-m-d'));

        $availability = $lodging->availability()
            ->whereBetween('date', [$startDate, $endDate])
            ->get()
            ->keyBy('date');

        // Fill in missing dates with default availability
        $period = CarbonPeriod::create($startDate, $endDate);
        $result = [];

        foreach ($period as $date) {
            $dateStr = $date->format('Y-m-d');
            if (isset($availability[$dateStr])) {
                $result[] = $availability[$dateStr];
            } else {
                $result[] = [
                    'date' => $dateStr,
                    'is_available' => true,
                    'price_override' => null,
                ];
            }
        }

        return response()->json(['data' => $result]);
    }

    public function update(Request $request, Lodging $lodging)
    {
        if ($lodging->host_id !== Auth::id()) {
            abort(403, 'Unauthorized');
        }

        $validated = $request->validate([
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
            'is_available' => 'required|boolean',
            'price_override' => 'nullable|numeric|min:0',
        ]);

        $period = CarbonPeriod::create($validated['start_date'], $validated['end_date']);

        foreach ($period as $date) {
            LodgingAvailability::updateOrCreate(
                [
                    'lodging_id' => $lodging->id,
                    'date' => $date->format('Y-m-d'),
                ],
                [
                    'is_available' => $validated['is_available'],
                    'price_override' => $validated['price_override'] ?? null,
                ]
            );
        }

        return response()->json(['message' => 'Availability updated successfully']);
    }
}
