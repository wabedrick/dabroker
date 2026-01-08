<?php

namespace Tests\Feature;

use App\Events\AuctionUpdated;
use App\Events\BidPlaced;
use App\Models\Auction;
use App\Models\Property;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Event;
use Tests\TestCase;

class AuctionTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_auction()
    {
        $user = User::factory()->create();
        $property = Property::factory()->create(['owner_id' => $user->id]);

        $response = $this->actingAs($user)->postJson('/api/v1/auctions', [
            'property_id' => $property->public_id,
            'start_time' => now()->addDay(),
            'end_time' => now()->addDays(2),
            'starting_price' => 100000,
            'reserve_price' => 150000,
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('auctions', [
            'property_id' => $property->id,
            'starting_price' => 100000,
        ]);
    }

    public function test_user_can_place_bid()
    {
        $this->withoutExceptionHandling();
        Event::fake();

        $seller = User::factory()->create();
        $buyer = User::factory()->create();
        $property = Property::factory()->create(['owner_id' => $seller->id]);
        
        $auction = Auction::create([
            'public_id' => \Illuminate\Support\Str::uuid(),
            'property_id' => $property->id,
            'seller_id' => $seller->id,
            'start_time' => now()->subHour(),
            'end_time' => now()->addHour(),
            'starting_price' => 100000,
            'status' => 'active',
        ]);

        $response = $this->actingAs($buyer)->postJson("/api/v1/auctions/{$auction->public_id}/bid", [
            'amount' => 110000,
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('bids', [
            'auction_id' => $auction->id,
            'user_id' => $buyer->id,
            'amount' => 110000,
        ]);

        Event::assertDispatched(BidPlaced::class);
    }

    public function test_auction_closes_correctly()
    {
        Event::fake();

        $seller = User::factory()->create();
        $buyer = User::factory()->create();
        $property = Property::factory()->create(['owner_id' => $seller->id]);
        
        $auction = Auction::create([
            'public_id' => \Illuminate\Support\Str::uuid(),
            'property_id' => $property->id,
            'seller_id' => $seller->id,
            'start_time' => now()->subDays(2),
            'end_time' => now()->subDay(), // Ended yesterday
            'starting_price' => 100000,
            'status' => 'active',
        ]);

        // Place a winning bid
        $auction->bids()->create([
            'public_id' => \Illuminate\Support\Str::uuid(),
            'user_id' => $buyer->id,
            'amount' => 120000,
        ]);

        $this->artisan('auction:close')
            ->assertExitCode(0);

        $auction->refresh();
        
        $this->assertEquals('completed', $auction->status);
        $this->assertNotNull($auction->winning_bid_id);
        
        Event::assertDispatched(AuctionUpdated::class);
    }
}
