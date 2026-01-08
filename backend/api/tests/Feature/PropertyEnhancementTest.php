<?php

namespace Tests\Feature;

use App\Models\Property;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Tests\TestCase;

class PropertyEnhancementTest extends TestCase
{
    use RefreshDatabase;

    public function setUp(): void
    {
        parent::setUp();
        // Create permission if it doesn't exist (it might be seeded or not)
        Permission::firstOrCreate(['name' => 'properties.create', 'guard_name' => 'web']);
    }

    public function test_price_history_is_tracked()
    {
        $user = User::factory()->create();
        $property = Property::factory()->create([
            'owner_id' => $user->id,
            'price' => 100000,
        ]);

        // Update price
        $property->update(['price' => 120000]);

        $this->assertDatabaseHas('property_price_histories', [
            'property_id' => $property->id,
            'old_price' => 100000,
            'new_price' => 120000,
        ]);
    }

    public function test_enhanced_fields_can_be_stored()
    {
        $user = User::factory()->create();
        $user->givePermissionTo('properties.create');
        
        $response = $this->actingAs($user)->postJson('/api/v1/owner/properties', [
            'title' => 'Luxury Villa',
            'type' => 'house',
            'price' => 500000,
            'currency' => 'USD',
            'city' => 'New York',
            'country' => 'USA',
            'video_url' => 'https://youtube.com/watch?v=123',
            'virtual_tour_url' => 'https://matterport.com/123',
            'nearby_places' => [
                [
                    'name' => 'Central Park',
                    'distance' => '500m',
                    'type' => 'park'
                ]
            ]
        ]);

        $response->assertStatus(201);
        
        $this->assertDatabaseHas('properties', [
            'video_url' => 'https://youtube.com/watch?v=123',
        ]);
    }
}
