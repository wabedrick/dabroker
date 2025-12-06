<?php

namespace Tests\Feature\Notification;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\PropertyInquiry;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotificationCounterTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_owner_receives_unread_counters(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyerOne = User::factory()->create(['preferred_role' => 'buyer']);
        $buyerTwo = User::factory()->create(['preferred_role' => 'buyer']);

        PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyerOne->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer1@example.com',
            'message' => 'First inquiry.',
            'status' => 'open',
            'buyer_read_at' => now(),
        ]);

        $readInquiry = PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyerTwo->id,
            'contact_method' => 'phone',
            'contact_value' => '+1234567890',
            'message' => 'Second inquiry.',
            'status' => 'open',
            'buyer_read_at' => now(),
        ]);
        $readInquiry->update(['read_at' => now()]);

        $buyerOne->favoriteProperties()->attach($property->id, ['owner_id' => $owner->id]);
        $buyerTwo->favoriteProperties()->attach($property->id, ['owner_id' => $owner->id, 'owner_read_at' => now()]);

        $this->actingAs($owner, 'sanctum')
            ->getJson('/api/v1/notifications/counters')
            ->assertOk()
            ->assertJsonPath('data.unread_inquiries', 1)
            ->assertJsonPath('data.buyer_unread_inquiries', 0)
            ->assertJsonPath('data.unread_favorites', 1)
            ->assertJsonPath('data.saved_favorites', 0);
    }

    public function test_buyer_unread_inquiries_increment_when_owner_replies(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $inquiry = PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyer->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer@example.com',
            'message' => 'Initial question.',
            'status' => 'open',
            'buyer_read_at' => now(),
        ]);

        $inquiry->update([
            'responded_at' => now(),
            'status' => PropertyInquiry::STATUS_RESPONDED,
            'buyer_read_at' => null,
        ]);

        $this->actingAs($buyer, 'sanctum')
            ->getJson('/api/v1/notifications/counters')
            ->assertOk()
            ->assertJsonPath('data.buyer_unread_inquiries', 1);
    }

    public function test_owner_can_acknowledge_favorite_alerts(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        $buyer->favoriteProperties()->attach($property->id, ['owner_id' => $owner->id]);

        $this->actingAs($owner, 'sanctum')
            ->postJson('/api/v1/notifications/favorites/acknowledge')
            ->assertOk()
            ->assertJson(['message' => 'Favorite alerts cleared.']);

        $this->actingAs($owner, 'sanctum')
            ->getJson('/api/v1/notifications/counters')
            ->assertJsonPath('data.unread_favorites', 0);
    }
}
