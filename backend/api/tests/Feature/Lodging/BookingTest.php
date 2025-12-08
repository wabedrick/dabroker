<?php

namespace Tests\Feature\Lodging;

use App\Models\Booking;
use App\Models\Lodging;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BookingTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_booking()
    {
        $user = User::factory()->create();
        $lodging = Lodging::factory()->create([
            'status' => 'approved',
            'price_per_night' => 100,
            'max_guests' => 4,
        ]);

        \Laravel\Sanctum\Sanctum::actingAs($user, ['*']);

        $response = $this->postJson('/api/v1/bookings', [
            'lodging_id' => $lodging->public_id,
            'check_in' => '2025-12-20',
            'check_out' => '2025-12-25',
            'guests_count' => 2,
            'rooms_count' => 1,
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('bookings', [
            'user_id' => $user->id,
            'lodging_id' => $lodging->id,
            'status' => 'pending',
            'total_price' => 500, // 5 nights * 100
        ]);
    }

    public function test_cannot_book_overlapping_dates()
    {
        $user = User::factory()->create();
        $lodging = Lodging::factory()->create(['status' => 'approved']);

        // Create existing booking
        Booking::factory()->create([
            'lodging_id' => $lodging->id,
            'check_in' => '2025-12-20',
            'check_out' => '2025-12-25',
            'status' => 'confirmed',
        ]);

        \Laravel\Sanctum\Sanctum::actingAs($user, ['*']);

        $response = $this->postJson('/api/v1/bookings', [
            'lodging_id' => $lodging->public_id,
            'check_in' => '2025-12-22',
            'check_out' => '2025-12-27',
            'guests_count' => 2,
            'rooms_count' => 1,
        ]);

        $response->assertStatus(400)
            ->assertJson(['message' => 'Not enough rooms available for selected dates. Available: 0']);
    }

    public function test_host_can_confirm_booking()
    {
        $host = User::factory()->create();
        $user = User::factory()->create();
        $lodging = Lodging::factory()->create(['host_id' => $host->id]);
        $booking = Booking::factory()->create([
            'user_id' => $user->id,
            'lodging_id' => $lodging->id,
            'status' => 'pending',
        ]);

        \Laravel\Sanctum\Sanctum::actingAs($host, ['*']);

        $response = $this->patchJson("/api/v1/bookings/{$booking->public_id}", [
            'status' => 'confirmed',
        ]);

        $response->assertStatus(200);
        $this->assertEquals('confirmed', $booking->fresh()->status);
        $this->assertNotNull($booking->fresh()->confirmed_at);
    }

    public function test_user_can_cancel_booking()
    {
        $user = User::factory()->create();
        $lodging = Lodging::factory()->create();
        $booking = Booking::factory()->create([
            'user_id' => $user->id,
            'lodging_id' => $lodging->id,
            'status' => 'pending',
        ]);

        \Laravel\Sanctum\Sanctum::actingAs($user, ['*']);

        $response = $this->patchJson("/api/v1/bookings/{$booking->public_id}", [
            'status' => 'cancelled',
        ]);

        $response->assertStatus(200);
        $this->assertEquals('cancelled', $booking->fresh()->status);
    }
}
