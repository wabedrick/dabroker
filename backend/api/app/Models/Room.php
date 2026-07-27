<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Room extends Model
{
    use HasFactory;

    protected $fillable = [
        'public_id',
        'property_id',
        'name',
        'price',
        'currency',
        'features',
        'is_available',
        'description',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'features' => 'array',
        'is_available' => 'boolean',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($room) {
            $room->public_id ??= (string) Str::uuid();
        });
    }

    public function getRouteKeyName()
    {
        return 'public_id';
    }

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }
}
