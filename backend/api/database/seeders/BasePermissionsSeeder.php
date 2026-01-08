<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Config;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class BasePermissionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $guards = ['web', 'api'];

        $permissions = [
            // Property lifecycle
            'properties.view',
            'properties.create',
            'properties.update',
            'properties.delete',
            'properties.approve',
            'properties.save',

            // Lodging lifecycle
            'lodgings.view',
            'lodgings.create',
            'lodgings.update',
            'lodgings.manage_availability',
            'lodgings.approve',

            // Bookings
            'bookings.create',
            'bookings.manage',
            'bookings.cancel',
            'bookings.review',

            // Professionals & consultations
            'professionals.view',
            'professionals.manage',
            'consultations.schedule',
            'consultations.manage',

            // Messaging & notifications
            'messaging.initiate',
            'messaging.respond',
            'notifications.manage',

            // Admin & analytics
            'admin.verify_users',
            'admin.manage_users',
            'admin.view_reports',
            'admin.manage_settings',
            'admin.manage_admins',
        ];

        foreach ($guards as $guard) {
            foreach ($permissions as $permission) {
                Permission::firstOrCreate([
                    'name' => $permission,
                    'guard_name' => $guard,
                ]);
            }

            $roles = [
                'buyer' => [
                    'properties.view',
                    'properties.save', // placeholder for saved listings
                    'bookings.create',
                    'bookings.manage',
                    'bookings.cancel',
                    'bookings.review',
                    'messaging.initiate',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'seller' => [
                    'properties.view',
                    'properties.create',
                    'properties.update',
                    'properties.delete',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'host' => [
                    'lodgings.view',
                    'lodgings.create',
                    'lodgings.update',
                    'lodgings.manage_availability',
                    'bookings.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'professional' => [
                    'professionals.view',
                    'professionals.manage',
                    'consultations.schedule',
                    'consultations.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'broker' => [
                    'professionals.view',
                    'professionals.manage',
                    'consultations.schedule',
                    'consultations.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'surveyor' => [
                    'professionals.view',
                    'professionals.manage',
                    'consultations.schedule',
                    'consultations.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'lawyer' => [
                    'professionals.view',
                    'professionals.manage',
                    'consultations.schedule',
                    'consultations.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'real_estate_agent' => [
                    'professionals.view',
                    'professionals.manage',
                    'consultations.schedule',
                    'consultations.manage',
                    'messaging.respond',
                    'notifications.manage',
                ],
                'admin' => array_diff($permissions, ['admin.manage_admins']),
                'super_admin' => $permissions,
            ];

            foreach ($roles as $role => $rolePermissions) {
                $roleModel = Role::firstOrCreate([
                    'name' => $role,
                    'guard_name' => $guard,
                ]);

                $roleModel->syncPermissions(array_intersect($permissions, $rolePermissions));
            }
        }
    }
}
