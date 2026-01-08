<?php

namespace App\Console\Commands;

use App\Events\AuctionUpdated;
use App\Models\Auction;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class CloseEndedAuctions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'auction:close';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Close auctions that have ended';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $auctions = Auction::where('status', 'active')
            ->where('end_time', '<=', now())
            ->get();

        foreach ($auctions as $auction) {
            DB::transaction(function () use ($auction) {
                $highestBid = $auction->bids()->orderByDesc('amount')->first();

                if ($highestBid) {
                    if ($auction->reserve_price && $highestBid->amount < $auction->reserve_price) {
                        $auction->update(['status' => 'unsold']);
                        $this->info("Auction {$auction->id} ended without meeting reserve price.");
                    } else {
                        $auction->update([
                            'status' => 'completed',
                            'winning_bid_id' => $highestBid->id,
                        ]);
                        $this->info("Auction {$auction->id} won by user {$highestBid->user_id} for {$highestBid->amount}.");
                    }
                } else {
                    $auction->update(['status' => 'unsold']);
                    $this->info("Auction {$auction->id} ended with no bids.");
                }
                
                broadcast(new AuctionUpdated($auction));
            });
        }
    }
}
