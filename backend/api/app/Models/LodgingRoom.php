<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class LodgingRoom extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'public_id',
        'lodging_id',
        'name',
        'price',
        'currency',
        'features',
        'capacity',
        'quantity',
        'room_type',
        'bed_type',
        'is_available',
        'description',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'features' => 'array',
        'is_available' => 'boolean',
        'capacity' => 'integer',
        'quantity' => 'integer',
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

    public function lodging(): BelongsTo
    {
        return $this->belongsTo(Lodging::class);
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
        // Conversions disabled to prevent timeouts
    }
}
