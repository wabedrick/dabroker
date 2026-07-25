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

        $checkIn = now()->addDays(10)->format('Y-m-d');
        $checkOut = now()->addDays(15)->format('Y-m-d');

        $response = $this->postJson('/api/v1/bookings', [
            'lodging_id' => $lodging->public_id,
            'check_in' => $checkIn,
            'check_out' => $checkOut,
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

        $checkIn1 = now()->addDays(10)->format('Y-m-d');
        $checkOut1 = now()->addDays(15)->format('Y-m-d');
        
        $checkIn2 = now()->addDays(12)->format('Y-m-d');
        $checkOut2 = now()->addDays(17)->format('Y-m-d');

        // Create existing booking
        Booking::factory()->create([
            'lodging_id' => $lodging->id,
            'check_in' => $checkIn1,
            'check_out' => $checkOut1,
            'status' => 'confirmed',
        ]);

        \Laravel\Sanctum\Sanctum::actingAs($user, ['*']);

        $response = $this->postJson('/api/v1/bookings', [
            'lodging_id' => $lodging->public_id,
            'check_in' => $checkIn2,
            'check_out' => $checkOut2,
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
