<?php

namespace Tests\Feature\Admin;

use App\Models\Lodging;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;
use Tests\TestCase;

class AdminLodgingControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        app(PermissionRegistrar::class)->forgetCachedPermissions();
        Permission::findOrCreate('properties.approve', 'web');
    }

    public function test_admin_can_list_lodgings(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');
        Lodging::factory()->count(2)->create();

        Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/lodgings');

        $response->assertOk();
        $response->assertJsonCount(2, 'data');
    }

    public function test_admin_can_filter_lodgings_by_status(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');

        Lodging::factory()->create(['status' => 'pending']);
        Lodging::factory()->create(['status' => 'approved']);

        Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/lodgings?status=pending');

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $this->assertEquals('pending', $response->json('data.0.status'));
    }

    public function test_non_admin_cannot_access_lodgings(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user, ['*']);

        $response = $this->getJson('/api/v1/admin/lodgings');

        $response->assertForbidden();
    }
}
