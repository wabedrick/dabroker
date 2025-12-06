<?php

use App\Models\User;
use App\Models\Lodging;
use App\Models\Booking;
use Illuminate\Support\Facades\Auth;

// Find a user who has lodgings
$host = User::whereHas('lodgings')->first();

if (!$host) {
    echo "No host found with lodgings.\n";
    exit;
}

echo "Host: {$host->name} (ID: {$host->id})\n";

// Get lodgings for this host
$lodgings = Lodging::where('host_id', $host->id)->get();
echo "Lodgings count: {$lodgings->count()}\n";

foreach ($lodgings as $lodging) {
    echo " - Lodging: {$lodging->title} (ID: {$lodging->id}, Public ID: {$lodging->public_id})\n";
    
    // Get bookings for this lodging
    $bookings = Booking::where('lodging_id', $lodging->id)->get();
    echo "   Bookings count: {$bookings->count()}\n";
    foreach ($bookings as $booking) {
        echo "    - Booking ID: {$booking->id}, Public ID: {$booking->public_id}, Status: {$booking->status}\n";
    }
}

// Simulate the controller query
Auth::login($host);
$controllerBookings = Booking::whereHas('lodging', function ($query) use ($host) {
    $query->where('host_id', $host->id);
})->count();

echo "Controller Query Count: {$controllerBookings}\n";
