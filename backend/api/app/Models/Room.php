<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Room extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'public_id',
        'property_id',
        'name',
        'price',
        'currency',
        'features',
        'is_available',
        'description',
        'capacity',
        'quantity',
        'room_type',
        'bed_type',
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

    public function registerMediaCollections(): void
    {
        $this
            ->addMediaCollection('gallery')
            ->useFallbackUrl(asset('images/placeholders/room.jpg'))
            ->useDisk(config('media-library.disk_name', config('filesystems.default', 'public')));
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        // Conversions disabled by default to prevent synchronous processing timeouts
        // $this
        //     ->addMediaConversion('thumb')
        //     ->width(400)
        //     ->height(300)
        //     ->sharpen(10)
        //     ->format('webp')
        //     ->performOnCollections('gallery');
    }
}
