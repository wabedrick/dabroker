<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PropertyFavoriteTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_buyer_can_favorite_approved_property(): void
    {
        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Approved,
        ]);

        $response = $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/favorites/properties/{$property->public_id}");

        $response->assertCreated()
            ->assertJson(['message' => 'Property saved to favorites.']);

        $this->assertDatabaseHas('property_favorites', [
            'user_id' => $buyer->id,
            'property_id' => $property->id,
        ]);
    }

    public function test_buyer_cannot_favorite_pending_property(): void
    {
        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/favorites/properties/{$property->public_id}")
            ->assertStatus(422);
    }

    public function test_buyer_can_list_and_remove_favorites(): void
    {
        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer->favoriteProperties()->attach($property->id);

        $response = $this->actingAs($buyer, 'sanctum')
            ->getJson('/api/v1/favorites/properties');

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.is_favorited', true)
            ->assertJsonPath('data.0.id', $property->public_id);

        $this->actingAs($buyer, 'sanctum')
            ->deleteJson("/api/v1/favorites/properties/{$property->public_id}")
            ->assertOk();

        $this->assertDatabaseMissing('property_favorites', [
            'user_id' => $buyer->id,
            'property_id' => $property->id,
        ]);
    }
}
