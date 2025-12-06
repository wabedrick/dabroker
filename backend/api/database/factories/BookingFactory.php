<?php

namespace Database\Factories;

use App\Models\Lodging;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class BookingFactory extends Factory
{
    public function definition(): array
    {
        $checkIn = fake()->dateTimeBetween('now', '+1 month');
        $checkOut = fake()->dateTimeBetween($checkIn, '+1 month');

        return [
            'user_id' => User::factory(),
            'lodging_id' => Lodging::factory(),
            'check_in' => $checkIn,
            'check_out' => $checkOut,
            'guests_count' => fake()->numberBetween(1, 4),
            'total_price' => fake()->randomFloat(2, 100, 1000),
            'status' => 'pending',
            'notes' => fake()->optional()->sentence(),
        ];
    }
}
