<?php

namespace Tests\Feature\Admin;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;
use Tests\TestCase;

class AdminModerationLogControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        app(PermissionRegistrar::class)->forgetCachedPermissions();
        Permission::findOrCreate('properties.approve', 'web');
    }

    public function test_admin_can_list_moderation_logs(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');

        $property = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        Sanctum::actingAs($admin, ['*']);

        $this->postJson("/api/v1/admin/properties/{$property->public_id}/approve")->assertOk();

        $response = $this->getJson('/api/v1/admin/moderation-logs');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $this->assertEquals('property_approved', $response->json('data.0.action'));
    }
}
