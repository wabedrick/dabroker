<?php

namespace Tests\Feature\Admin;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;
use Tests\TestCase;

class AdminUserControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        app(PermissionRegistrar::class)->forgetCachedPermissions();
        Permission::findOrCreate('properties.approve', 'web');
        Permission::findOrCreate('admin.manage_users', 'web');
    }

    public function test_admin_can_update_user_status(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo(['properties.approve', 'admin.manage_users']);
        $user = User::factory()->create(['status' => 'active']);

        Sanctum::actingAs($admin, ['*']);

        $response = $this->patchJson("/api/v1/admin/users/{$user->id}", [
            'status' => 'suspended',
        ]);

        $response->assertOk();
        $this->assertEquals('suspended', $user->fresh()->status);
    }

    public function test_missing_manage_users_permission_cannot_update(): void
    {
        $admin = User::factory()->create();
        $admin->givePermissionTo('properties.approve');
        $user = User::factory()->create();

        Sanctum::actingAs($admin, ['*']);

        $response = $this->patchJson("/api/v1/admin/users/{$user->id}", [
            'status' => 'suspended',
        ]);

        $response->assertForbidden();
    }
}
