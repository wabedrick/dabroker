<?php

namespace App\Http\Controllers;

use App\Models\Auction;
use App\Models\Bid;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

use App\Events\BidPlaced;

use Illuminate\Support\Str;

class AuctionController extends Controller
{
    public function index(Request $request)
    {
        $auctions = Auction::with(['property', 'highestBid'])
            ->where('status', 'active')
            ->where('end_time', '>', now())
            ->latest()
            ->paginate(20);

        return response()->json($auctions);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'property_id' => 'required|exists:properties,public_id',
            'start_time' => 'required|date|after:now',
            'end_time' => 'required|date|after:start_time',
            'starting_price' => 'required|numeric|min:0',
            'reserve_price' => 'nullable|numeric|min:0',
        ]);

        $property = Property::where('public_id', $validated['property_id'])->firstOrFail();

        if ($property->owner_id !== Auth::id()) {
             return response()->json(['message' => 'Unauthorized'], 403);
        }

        $auction = Auction::create([
            'public_id' => (string) Str::uuid(),
            'property_id' => $property->id,
            'seller_id' => Auth::id(),
            'start_time' => $validated['start_time'],
            'end_time' => $validated['end_time'],
            'starting_price' => $validated['starting_price'],
            'reserve_price' => $validated['reserve_price'],
            'status' => 'scheduled',
        ]);

        return response()->json($auction, 201);
    }

    public function show(Auction $auction)
    {
        $auction->load(['property', 'bids.user', 'highestBid']);
        return response()->json($auction);
    }

    public function placeBid(Request $request, Auction $auction)
    {
        if ($auction->status !== 'active' || $auction->end_time < now() || $auction->start_time > now()) {
            return response()->json(['message' => 'Auction is not active'], 400);
        }

        $validated = $request->validate([
            'amount' => 'required|numeric',
        ]);

        $amount = $validated['amount'];

        $minBid = $auction->current_price ? $auction->current_price : $auction->starting_price;
        
        if ($amount <= $minBid) {
             return response()->json(['message' => 'Bid must be higher than current price'], 400);
        }

        $bid = DB::transaction(function () use ($auction, $amount, $request) {
            $bid = Bid::create([
                'public_id' => (string) Str::uuid(),
                'auction_id' => $auction->id,
                'user_id' => Auth::id(),
                'amount' => $amount,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);

            $auction->update(['current_price' => $amount]);
            
            return $bid;
        });

        $bid->load('auction');
        broadcast(new BidPlaced($bid))->toOthers();

        return response()->json($bid, 201);
    }
}
