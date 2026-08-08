<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Lodging;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\DB;

class LodgingBrowseController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Lodging::query()
            ->approved()
            ->where('is_available', true)
            ->with(['host.roles', 'host.permissions', 'media'])
            ->withAvg('ratings as average_rating', 'rating')
            ->withCount('ratings');

        // Filter by type
        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        // Filter by city
        if ($request->has('city')) {
            $query->where('city', 'like', "%{$request->city}%");
        }

        // Filter by price range and currency
        if ($request->has('min_price') || $request->has('max_price')) {
            $minPrice = $request->has('min_price') ? (float) $request->min_price : null;
            $maxPrice = $request->has('max_price') ? (float) $request->max_price : null;
            $requestCurrency = $request->input('currency', 'UGX');
            $exchangeRate = config('app.exchange_rate_usd_ugx', 3800); // Default approx rate

            $query->where(function ($q) use ($requestCurrency, $minPrice, $maxPrice, $exchangeRate) {
                if ($requestCurrency === 'UGX') {
                    $usdMin = $minPrice !== null ? $minPrice / $exchangeRate : null;
                    $usdMax = $maxPrice !== null ? $maxPrice / $exchangeRate : null;

                    $q->where(function ($subQ) use ($minPrice, $maxPrice) {
                        $subQ->where('currency', 'UGX');
                        if ($minPrice !== null) $subQ->where('price_per_night', '>=', $minPrice);
                        if ($maxPrice !== null) $subQ->where('price_per_night', '<=', $maxPrice);
                    })->orWhere(function ($subQ) use ($usdMin, $usdMax) {
                        $subQ->where('currency', 'USD');
                        if ($usdMin !== null) $subQ->where('price_per_night', '>=', $usdMin);
                        if ($usdMax !== null) $subQ->where('price_per_night', '<=', $usdMax);
                    });
                } else {
                    $ugxMin = $minPrice !== null ? $minPrice * $exchangeRate : null;
                    $ugxMax = $maxPrice !== null ? $maxPrice * $exchangeRate : null;

                    $q->where(function ($subQ) use ($minPrice, $maxPrice) {
                        $subQ->where('currency', 'USD');
                        if ($minPrice !== null) $subQ->where('price_per_night', '>=', $minPrice);
                        if ($maxPrice !== null) $subQ->where('price_per_night', '<=', $maxPrice);
                    })->orWhere(function ($subQ) use ($ugxMin, $ugxMax) {
                        $subQ->where('currency', 'UGX');
                        if ($ugxMin !== null) $subQ->where('price_per_night', '>=', $ugxMin);
                        if ($ugxMax !== null) $subQ->where('price_per_night', '<=', $ugxMax);
                    });
                }
            });
        }

        // Filter by max guests
        if ($request->has('guests')) {
            $query->where('max_guests', '>=', $request->guests);
        }

        // Filter by amenities
        if ($request->has('amenities')) {
            $amenities = is_array($request->amenities) ? $request->amenities : [$request->amenities];
            foreach ($amenities as $amenity) {
                $query->whereJsonContains('amenities', $amenity);
            }
        }

        // Filter by check-in/check-out dates (availability)
        if ($request->has('check_in') && $request->has('check_out')) {
            $checkIn = $request->check_in;
            $checkOut = $request->check_out;
            $requestedRooms = $request->input('rooms_count', 1);

            $query->whereRaw("(
                total_rooms - (
                    SELECT COALESCE(SUM(rooms_count), 0)
                    FROM bookings
                    WHERE bookings.lodging_id = lodgings.id
                    AND bookings.status = 'confirmed'
                    AND (
                        (check_in BETWEEN ? AND ?)
                        OR (check_out BETWEEN ? AND ?)
                        OR (check_in <= ? AND check_out >= ?)
                    )
                )
            ) >= ?", [$checkIn, $checkOut, $checkIn, $checkOut, $checkIn, $checkOut, $requestedRooms]);
        }

        // Search keyword
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%")
                    ->orWhere('city', 'like', "%{$search}%");
            });
        }

        // Filter by location (radius search)
        if ($request->has('latitude') && $request->has('longitude') && $request->has('radius')) {
            $lat = (float) $request->latitude;
            $lng = (float) $request->longitude;
            $radius = (float) $request->radius; // in km

            // Apply bounding box pre-filter for performance
            $degreeRadius = $radius / 111;
            $query->whereBetween('latitude', [$lat - $degreeRadius, $lat + $degreeRadius])
                ->whereBetween('longitude', [$lng - $degreeRadius, $lng + $degreeRadius]);

            $haversine = "( 6371 * acos( cos( radians(?) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(?) ) + sin( radians(?) ) * sin( radians( latitude ) ) ) )";

            $query->selectRaw("lodgings.*, {$haversine} AS distance", [$lat, $lng, $lat])
                ->whereRaw("{$haversine} < ?", [$lat, $lng, $lat, $radius]);
        } elseif ($request->has('north') && $request->has('south') && $request->has('east') && $request->has('west')) {
            // Filter by bounds (map search)
            $query->whereBetween('latitude', [$request->south, $request->north])
                ->whereBetween('longitude', [$request->west, $request->east]);
        }

        // Sorting
        $sortBy = $request->input('sort_by', 'default');

        if ($sortBy === 'price_asc') {
            $query->orderBy('price_per_night', 'asc');
        } elseif ($sortBy === 'price_desc') {
            $query->orderBy('price_per_night', 'desc');
        } elseif ($sortBy === 'nearest' && $request->has('latitude') && $request->has('longitude')) {
            // Distance calculation must be present in select for this to work
            // If it wasn't added by the radius filter, we need to add it here if we want to sort by it
            // But usually 'nearest' implies we have a reference point.
            // If radius filter was applied, 'distance' column exists.
            // If not, we might need to add it, but for now let's assume nearest only works with radius or if we add logic.
            // Actually, if radius is NOT set but we want nearest, we need to add the selectRaw.

            if (!$request->has('radius')) {
                $lat = $request->latitude;
                $lng = $request->longitude;
                $haversine = "( 6371 * acos( cos( radians(?) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(?) ) + sin( radians(?) ) * sin( radians( latitude ) ) ) )";
                $query->selectRaw("lodgings.*, {$haversine} AS distance", [$lat, $lng, $lat]);
            }
            $query->orderBy('distance', 'asc');
        } else {
            // Default sorting
            if ($request->has('radius') && $request->has('latitude')) {
                $query->orderBy('distance', 'asc');
            } else {
                // Default sort: Highest rated first, then newest
                $query->orderByDesc('average_rating')->latest();
            }
        }

        $lodgings = $query->paginate(20);

        return \App\Http\Resources\LodgingResource::collection($lodgings);
    }

    public function show(Lodging $lodging)
    {
        /** @var \App\Models\User|null $user */
        $user = auth('sanctum')->user();
        $isHost = $user && $user->id === $lodging->host_id;
        $isAdmin = $user && ($user->hasRole('admin') || $user->hasRole('super_admin'));

        if (! $isHost && ! $isAdmin) {
            if ($lodging->status !== 'approved' || ! $lodging->is_available) {
                abort(404);
            }
        }

        $lodging->load(['host.roles', 'host.permissions', 'media', 'rooms', 'rooms.media']);

        return new \App\Http\Resources\LodgingResource($lodging);
    }
}
