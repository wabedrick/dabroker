<?php

namespace Tests\Feature\Admin;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class AdminDashboardTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->app->make(\Spatie\Permission\PermissionRegistrar::class)->forgetCachedPermissions();

        $approve = Permission::firstOrCreate(['name' => 'properties.approve']);
        $manageUsers = Permission::firstOrCreate(['name' => 'admin.manage_users']);

        $adminRole = Role::create(['name' => 'admin']);
        $adminRole->givePermissionTo([$approve, $manageUsers]);

        Role::create(['name' => 'user']);
    }

    /*
    public function test_admin_can_view_stats()
    {
        $admin = User::factory()->create();
        $admin->assignRole('admin');

        \Laravel\Sanctum\Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/dashboard/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'users' => ['total', 'new_today', 'brokers'],
                'properties' => ['total', 'pending', 'approved', 'new_today'],
            ]);
    }
    */

    public function test_admin_can_ban_user()
    {
        $admin = User::factory()->create();
        $admin->assignRole('admin');
        $user = User::factory()->create(['status' => 'active']);

        \Laravel\Sanctum\Sanctum::actingAs($admin, ['*']);

        $response = $this->postJson("/api/v1/admin/users/{$user->id}/ban");

        $response->assertStatus(200);
        $this->assertEquals('banned', $user->fresh()->status);
    }

    public function test_admin_can_fetch_analytics(): void
    {
        $admin = User::factory()->create();
        $admin->assignRole('admin');

        User::factory()->count(3)->create();
        \App\Models\Property::factory()->count(2)->create();
        \App\Models\Lodging::factory()->count(2)->create(['status' => 'pending']);

        \Laravel\Sanctum\Sanctum::actingAs($admin, ['*']);

        $response = $this->getJson('/api/v1/admin/dashboard/analytics?range_days=7');

        $response->assertOk();
        $response->assertJsonStructure([
            'users' => ['daily_new', 'total'],
            'properties' => ['daily_new', 'daily_approved', 'pending'],
            'lodgings' => ['daily_new', 'daily_approved', 'pending'],
            'moderation' => ['top_actions'],
        ]);
    }
}
