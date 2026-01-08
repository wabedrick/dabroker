<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\ProfessionalProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DemoProfessionalSeeder extends Seeder
{
    public function run(): void
    {
        $professionals = [
            [
                'name' => 'John Broker',
                'email' => 'broker@example.com',
                'role' => 'broker',
                'specialties' => ['Residential', 'Commercial'],
            ],
            [
                'name' => 'Jane Surveyor',
                'email' => 'surveyor@example.com',
                'role' => 'surveyor',
                'specialties' => ['Land Surveying', 'Topographic'],
            ],
            [
                'name' => 'Mike Lawyer',
                'email' => 'lawyer@example.com',
                'role' => 'lawyer',
                'specialties' => ['Property Law', 'Contracts'],
            ],
            [
                'name' => 'Sarah Agent',
                'email' => 'agent@example.com',
                'role' => 'real_estate_agent',
                'specialties' => ['Sales', 'Rentals'],
            ],
        ];

        foreach ($professionals as $data) {
            $user = User::firstOrCreate(
                ['email' => $data['email']],
                [
                    'name' => $data['name'],
                    'phone' => '+2567' . rand(10000000, 99999999),
                    'country_code' => '+256',
                    'password' => Hash::make('Password#123'),
                    'status' => 'active',
                    'preferred_role' => $data['role'],
                ]
            );

            if (!$user->hasRole($data['role'])) {
                $user->assignRole($data['role']);
            }

            // Also assign generic professional role
            if (!$user->hasRole('professional')) {
                $user->assignRole('professional');
            }

            ProfessionalProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'license_number' => 'LIC-' . strtoupper(substr($data['role'], 0, 3)) . '-' . rand(1000, 9999),
                    'specialties' => $data['specialties'],
                    'bio' => "Experienced {$data['role']} with over 10 years of practice.",
                    'hourly_rate' => rand(50, 200) * 1000,
                    'verification_status' => 'verified',
                ]
            );
        }
    }
}
