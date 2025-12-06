<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\PropertyFavorite;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class InterestedBuyerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_owner_can_list_interested_buyers(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $propertyOne = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $propertyTwo = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyerOne = User::factory()->create(['preferred_role' => 'buyer']);
        $buyerTwo = User::factory()->create(['preferred_role' => 'buyer']);

        PropertyFavorite::create([
            'user_id' => $buyerOne->id,
            'property_id' => $propertyOne->id,
            'owner_id' => $owner->id,
        ]);

        PropertyFavorite::create([
            'user_id' => $buyerTwo->id,
            'property_id' => $propertyTwo->id,
            'owner_id' => $owner->id,
            'owner_read_at' => now(),
        ]);

        $response = $this->actingAs($owner, 'sanctum')
            ->getJson('/api/v1/owner/interested-buyers?unread_only=1');

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.property.id', $propertyOne->public_id)
            ->assertJsonPath('data.0.buyer.id', $buyerOne->id);
    }

    public function test_owner_can_mark_interested_buyer_as_read(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        $favorite = PropertyFavorite::create([
            'user_id' => $buyer->id,
            'property_id' => $property->id,
            'owner_id' => $owner->id,
        ]);

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/owner/interested-buyers/{$favorite->public_id}/read")
            ->assertOk()
            ->assertJson(['message' => 'Favorite marked as reviewed.']);

        $this->assertNotNull($favorite->fresh()->owner_read_at);
    }

    public function test_owner_cannot_manage_foreign_favorites(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $otherOwner = User::factory()->create(['preferred_role' => 'seller']);
        $otherOwner->assignRole('seller');

        $property = Property::factory()->for($otherOwner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        $favorite = PropertyFavorite::create([
            'user_id' => $buyer->id,
            'property_id' => $property->id,
            'owner_id' => $otherOwner->id,
        ]);

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/owner/interested-buyers/{$favorite->public_id}/read")
            ->assertForbidden();
    }
}
