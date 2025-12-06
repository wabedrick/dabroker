<?php

namespace Database\Seeders;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Sequence;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DemoPropertySeeder extends Seeder
{
    public function run(): void
    {
        $host = User::firstOrCreate(
            ['email' => 'demo.host@example.com'],
            [
                'name' => 'Demo Host',
                'phone' => '+256700000888',
                'country_code' => '+256',
                'password' => Hash::make('Password#123'),
                'status' => 'active',
                'preferred_role' => 'host',
            ],
        );

        if (! $host->hasRole('host')) {
            $host->assignRole('host');
        }

        // Avoid duplicating demo listings on repeated runs
        if (Property::where('owner_id', $host->id)->exists()) {
            return;
        }

        $properties = Property::factory()
            ->count(3)
            ->for($host, 'owner')
            ->state(new Sequence(
                [
                    'title' => 'Lakeside Executive Apartment',
                    'type' => 'house',
                    'category' => 'apartment',
                    'city' => 'Kampala',
                    'state' => 'Central Region',
                    'country' => 'Uganda',
                    'price' => 450000,
                    'currency' => 'UGX',
                    'description' => 'Fully furnished three bedroom apartment overlooking Lake Victoria with premium amenities.',
                    'amenities' => ['wifi', 'parking', 'pool', 'security'],
                ],
                [
                    'title' => 'Garden Estate Family Home',
                    'type' => 'house',
                    'category' => 'estate',
                    'city' => 'Entebbe',
                    'state' => 'Central Region',
                    'country' => 'Uganda',
                    'price' => 380000,
                    'currency' => 'UGX',
                    'description' => 'Spacious standalone home with mature gardens, perfect for families and long stays.',
                    'amenities' => ['wifi', 'parking', 'water', 'solar'],
                ],
                [
                    'title' => 'Hilltop Serviced Plot',
                    'type' => 'land',
                    'category' => 'bungalow',
                    'city' => 'Jinja',
                    'state' => 'Eastern Region',
                    'country' => 'Uganda',
                    'price' => 120000,
                    'currency' => 'UGX',
                    'description' => 'Serviced plot with panoramic views ideal for quick development projects.',
                    'amenities' => ['water', 'power', 'road_access'],
                ],
            ))
            ->create([
                'status' => PropertyStatus::Approved,
                'approved_at' => now(),
                'published_at' => now(),
            ]);

        $images = [
            'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800&q=80',
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80',
            'https://images.unsplash.com/photo-1600596542815-27bfef40e5c6?w=800&q=80',
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
        ];

        foreach ($properties as $index => $property) {
            try {
                $property->addMediaFromUrl($images[$index % count($images)])
                    ->toMediaCollection('gallery');

                $property->addMediaFromUrl($images[($index + 1) % count($images)])
                    ->toMediaCollection('gallery');
            } catch (\Throwable $e) {
                // Ignore download errors
            }
        }
    }
}
