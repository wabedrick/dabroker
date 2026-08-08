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
        if (array_key_exists('average_rating', $this->attributes)) {
            return (float) ($this->attributes['average_rating'] ?? 0);
        }
        return (float) ($this->ratings()->avg('rating') ?? 0);
    }

    public function ratingsCount(): int
    {
        if (array_key_exists('ratings_count', $this->attributes)) {
            return (int) ($this->attributes['ratings_count'] ?? 0);
        }
        return $this->ratings()->count();
    }
}
