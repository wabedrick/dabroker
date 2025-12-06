<?php

namespace Database\Factories;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/** @extends Factory<Property> */
class PropertyFactory extends Factory
{
    protected $model = Property::class;

    public function definition(): array
    {
        $title = fake()->sentence(3);

        return [
            'public_id' => (string) Str::uuid(),
            'owner_id' => User::factory(),
            'title' => $title,
            'slug' => Str::slug($title . '-' . Str::random(6)),
            'type' => fake()->randomElement(['land', 'house']),
            'category' => fake()->randomElement(['bungalow', 'apartment', 'estate']),
            'status' => PropertyStatus::Approved,
            'price' => fake()->numberBetween(20000, 250000),
            'currency' => 'USD',
            'size' => fake()->numberBetween(50, 800),
            'size_unit' => 'sqm',
            'house_age' => fake()->numberBetween(0, 20),
            'address' => fake()->streetAddress(),
            'city' => fake()->city(),
            'state' => fake()->state(),
            'country' => fake()->country(),
            'postal_code' => fake()->postcode(),
            'latitude' => fake()->latitude(),
            'longitude' => fake()->longitude(),
            'amenities' => ['wifi', 'parking', 'water'],
            'metadata' => ['listing_source' => 'factory'],
            'description' => fake()->paragraph(),
            'published_at' => now(),
            'approved_at' => now(),
            'rejection_reason' => null,
        ];
    }
}
