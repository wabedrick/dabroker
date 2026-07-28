<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

try {
    DB::enableQueryLog();
    $query = \App\Models\Property::query();
    // Simulate applyFavoriteFlag WITHOUT applyFilters adding select
    $query->withExists([
        'favoritedBy as is_favorited' => fn($q) => $q->where('user_id', 1)
    ]);
    $query->get();
    print_r(DB::getQueryLog());
    echo "SUCCESS\n";
} catch (\Throwable $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
