<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PropertyLifecycleTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_owner_can_create_property(): void
    {
        $owner = User::factory()->create([
            'preferred_role' => 'seller',
        ]);
        $owner->assignRole('seller');

        $payload = [
            'title' => 'Sunset Villa',
            'type' => 'house',
            'category' => 'villa',
            'price' => 250000,
            'currency' => 'USD',
            'size' => 280,
            'size_unit' => 'sqm',
            'house_age' => 2,
            'city' => 'Kampala',
            'country' => 'Uganda',
            'address' => '123 Palm Street',
            'postal_code' => '256',
        ];

        $response = $this->actingAs($owner, 'sanctum')
            ->postJson('/api/v1/owner/properties', $payload);

        $response->assertCreated()
            ->assertJsonPath('data.status', PropertyStatus::Pending->value)
            ->assertJsonPath('data.title', 'Sunset Villa');

        $this->assertDatabaseHas('properties', [
            'owner_id' => $owner->id,
            'title' => 'Sunset Villa',
            'status' => PropertyStatus::Pending->value,
        ]);
    }

    public function test_owner_cannot_update_approved_property(): void
    {
        $owner = User::factory()->create([
            'preferred_role' => 'seller',
        ]);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $response = $this->actingAs($owner, 'sanctum')
            ->patchJson("/api/v1/owner/properties/{$property->public_id}", [
                'title' => 'Updated Title',
            ]);

        $response->assertForbidden();
    }

    public function test_admin_can_approve_pending_property(): void
    {
        $admin = User::factory()->create([
            'preferred_role' => 'admin',
        ]);
        $admin->assignRole('admin');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        $response = $this->actingAs($admin, 'sanctum')
            ->postJson("/api/v1/admin/properties/{$property->public_id}/approve");

        $response->assertOk()
            ->assertJsonPath('data.status', PropertyStatus::Approved->value)
            ->assertJsonPath('data.approved_by', $admin->id);

        $this->assertDatabaseHas('properties', [
            'id' => $property->id,
            'status' => PropertyStatus::Approved->value,
            'approved_by' => $admin->id,
        ]);
    }

    public function test_admin_can_reject_property_with_reason(): void
    {
        $admin = User::factory()->create([
            'preferred_role' => 'admin',
        ]);
        $admin->assignRole('admin');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        $response = $this->actingAs($admin, 'sanctum')
            ->postJson("/api/v1/admin/properties/{$property->public_id}/reject", [
                'reason' => 'Missing ownership documents.',
            ]);

        $response->assertOk()
            ->assertJsonPath('data.status', PropertyStatus::Rejected->value)
            ->assertJsonPath('data.rejection_reason', 'Missing ownership documents.');

        $this->assertDatabaseHas('properties', [
            'id' => $property->id,
            'status' => PropertyStatus::Rejected->value,
            'rejection_reason' => 'Missing ownership documents.',
        ]);
    }
}
