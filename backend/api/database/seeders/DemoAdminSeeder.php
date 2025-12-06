<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DemoAdminSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::firstOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Demo Admin',
                'phone' => '+256700000999',
                'country_code' => '+256',
                'password' => Hash::make('Admin#1234'),
                'status' => 'active',
                'preferred_role' => 'admin',
            ],
        );

        // Assign super_admin role for both guards
        foreach (['web', 'api'] as $guard) {
            $role = \Spatie\Permission\Models\Role::where('name', 'super_admin')
                ->where('guard_name', $guard)
                ->first();

            if ($role && ! $admin->hasRole($role)) {
                $admin->assignRole($role);
            }
        }
    }
}
