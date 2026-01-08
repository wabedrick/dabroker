<?php

namespace App\Models\Traits;

use App\Models\Rating;
use Illuminate\Database\Eloquent\Relations\MorphMany;

trait Rateable
{
    public function ratings(): MorphMany
    {
        return $this->morphMany(Rating::class, 'rateable');
    }

    public function averageRating(): float
    {
        return (float) ($this->ratings()->avg('rating') ?? 0);
    }

    public function ratingsCount(): int
    {
        return $this->ratings()->count();
    }
}
