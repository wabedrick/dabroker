<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class LodgingFactory extends Factory
{
    public function definition(): array
    {
        return [
            'host_id' => User::factory(),
            'title' => fake()->sentence(3),
            'type' => fake()->randomElement(['hotel', 'apartment', 'hostel', 'guesthouse', 'villa', 'cabin']),
            'status' => 'pending',
            'price_per_night' => fake()->randomFloat(2, 50, 500),
            'currency' => 'USD',
            'max_guests' => fake()->numberBetween(1, 8),
            'description' => fake()->paragraph(),
            'address' => fake()->streetAddress(),
            'city' => fake()->city(),
            'state' => fake()->state(),
            'country' => fake()->country(),
            'postal_code' => fake()->postcode(),
            'latitude' => fake()->latitude(),
            'longitude' => fake()->longitude(),
            'amenities' => fake()->randomElements(['wifi', 'parking', 'pool', 'gym', 'kitchen', 'ac'], 3),
            'rules' => ['no_smoking' => true, 'no_pets' => false],
            'metadata' => [],
        ];
    }
}
