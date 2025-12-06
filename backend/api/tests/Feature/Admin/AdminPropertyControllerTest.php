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

class AdminPropertyControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        app(PermissionRegistrar::class)->forgetCachedPermissions();
        Permission::findOrCreate('properties.approve', 'web');
    }

    public function test_admin_can_list_properties(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');
        Property::factory()->count(2)->create();

        Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/properties');

        $response->assertOk();
        $response->assertJsonCount(2, 'data');
    }

    public function test_admin_can_filter_properties_by_status(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');

        Property::factory()->create(['status' => PropertyStatus::Pending]);
        Property::factory()->create(['status' => PropertyStatus::Approved]);

        Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/properties?status=pending');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $this->assertEquals('pending', $response->json('data.0.status'));
    }

    public function test_non_admin_cannot_access_properties(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user, ['*']);

        $response = $this->getJson('/api/v1/admin/properties');

        $response->assertForbidden();
    }
}
