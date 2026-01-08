<?php

namespace Tests\Feature\Lodging;

use App\Models\Lodging;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LodgingTest extends TestCase
{
    use RefreshDatabase;

    public function test_host_can_create_lodging()
    {
        $host = User::factory()->create();

        \Laravel\Sanctum\Sanctum::actingAs($host, ['*']);

        $response = $this->postJson('/api/v1/host/lodgings', [
            'title' => 'Beautiful Apartment',
            'type' => 'apartment',
            'price_per_night' => 100,
            'max_guests' => 4,
            'description' => 'A beautiful apartment in the city center',
            'city' => 'Kampala',
            'country' => 'Uganda',
            'currency' => 'UGX',
            'total_rooms' => 2,
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('lodgings', [
            'title' => 'Beautiful Apartment',
            'host_id' => $host->id,
            'status' => 'pending',
        ]);
    }

    public function test_user_can_search_approved_lodgings()
    {
        $lodging = Lodging::factory()->create(['status' => 'approved']);
        Lodging::factory()->create(['status' => 'pending']); // Should not appear

        $response = $this->getJson('/api/v1/lodgings');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data');
    }

    public function test_user_can_filter_lodgings_by_city()
    {
        Lodging::factory()->create(['status' => 'approved', 'city' => 'Kampala']);
        Lodging::factory()->create(['status' => 'approved', 'city' => 'Nairobi']);

        $response = $this->getJson('/api/v1/lodgings?city=Kampala');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data');
    }

    public function test_host_can_set_availability()
    {
        $host = User::factory()->create();
        $lodging = Lodging::factory()->create(['host_id' => $host->id]);

        \Laravel\Sanctum\Sanctum::actingAs($host, ['*']);

        $response = $this->putJson("/api/v1/host/lodgings/{$lodging->public_id}/availability", [
            'start_date' => '2025-12-01',
            'end_date' => '2025-12-10',
            'is_available' => false,
        ]);

        $response->assertStatus(200);

        // Verify availability was set
        $availability = \App\Models\LodgingAvailability::where('lodging_id', $lodging->id)
            ->whereDate('date', '2025-12-01')
            ->first();

        $this->assertNotNull($availability);
        $this->assertEquals(0, $availability->is_available);
    }
}
