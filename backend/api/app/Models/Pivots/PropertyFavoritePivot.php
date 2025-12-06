<?php

namespace App\Models\Pivots;

use App\Models\Property;
use Illuminate\Database\Eloquent\Relations\Pivot;
use Illuminate\Support\Str;

class PropertyFavoritePivot extends Pivot
{
    protected $table = 'property_favorites';

    protected static function booted(): void
    {
        static::creating(function (PropertyFavoritePivot $pivot): void {
            $pivot->public_id ??= (string) Str::uuid();

            if (! $pivot->owner_id && $pivot->property_id) {
                $pivot->owner_id = Property::query()->where('id', $pivot->property_id)->value('owner_id');
            }
        });
    }
}
