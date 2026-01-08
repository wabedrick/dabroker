<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class ProfessionalRolesSeeder extends Seeder
{
    public function run(): void
    {
        $guards = ['web', 'api'];

        // Permissions for professionals (copied from BasePermissionsSeeder)
        $professionalPermissions = [
            'professionals.view',
            'professionals.manage',
            'consultations.schedule',
            'consultations.manage',
            'messaging.respond',
            'notifications.manage',
        ];

        // Ensure permissions exist (just in case)
        foreach ($guards as $guard) {
            foreach ($professionalPermissions as $permission) {
                Permission::firstOrCreate([
                    'name' => $permission,
                    'guard_name' => $guard,
                ]);
            }
        }

        $roles = ['broker', 'surveyor', 'lawyer'];

        foreach ($guards as $guard) {
            foreach ($roles as $roleName) {
                $role = Role::firstOrCreate([
                    'name' => $roleName,
                    'guard_name' => $guard,
                ]);

                $role->syncPermissions($professionalPermissions);
            }
        }

        // Assign these roles to existing professionals so we have data to test
        $professionals = \App\Models\User::role('professional')->get();
        foreach ($professionals as $user) {
            // Randomly assign one of the new roles
            $newRole = $roles[array_rand($roles)];

            // Assign the role
            $user->assignRole($newRole);

            // Update preferred_role to match
            $user->update(['preferred_role' => $newRole]);
        }
    }
}
