<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PropertyFavorite extends Model
{
    protected $table = 'property_favorites';

    public $timestamps = true;

    protected $fillable = [
        'public_id',
        'user_id',
        'property_id',
        'owner_id',
        'owner_read_at',
    ];

    protected $casts = [
        'owner_read_at' => 'datetime',
    ];

    protected static function booted(): void
    {
        static::creating(function (PropertyFavorite $favorite): void {
            $favorite->public_id ??= (string) Str::uuid();
            $favorite->owner_id ??= Property::query()->where('id', $favorite->property_id)->value('owner_id');
        });
    }

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function getRouteKeyName(): string
    {
        return 'public_id';
    }
}
