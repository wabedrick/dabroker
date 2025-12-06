<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;
use Laravel\Scout\Searchable;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Lodging extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, Searchable, SoftDeletes;

    protected $fillable = [
        'public_id',
        'host_id',
        'title',
        'slug',
        'type',
        'status',
        'is_available',
        'price_per_night',
        'currency',
        'max_guests',
        'total_rooms',
        'description',
        'address',
        'city',
        'state',
        'country',
        'postal_code',
        'latitude',
        'longitude',
        'amenities',
        'rules',
        'metadata',
        'published_at',
        'approved_at',
        'approved_by',
        'rejection_reason',
    ];

    protected $casts = [
        'price_per_night' => 'decimal:2',
        'latitude' => 'decimal:7',
        'is_available' => 'boolean',
        'longitude' => 'decimal:7',
        'amenities' => 'array',
        'rules' => 'array',
        'metadata' => 'array',
        'published_at' => 'datetime',
        'approved_at' => 'datetime',
        'max_guests' => 'integer',
    ];

    protected static function booted(): void
    {
        static::creating(function (Lodging $lodging): void {
            $lodging->public_id ??= (string) Str::uuid();
            $lodging->slug ??= Str::slug(Str::limit($lodging->title, 60) . '-' . Str::random(6));
        });
    }

    public function getRouteKeyName(): string
    {
        return 'public_id';
    }

    public function host(): BelongsTo
    {
        return $this->belongsTo(User::class, 'host_id');
    }

    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function availability(): HasMany
    {
        return $this->hasMany(LodgingAvailability::class);
    }

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }

    public function scopeApproved($query)
    {
        return $query->where('status', 'approved');
    }

    public function shouldBeSearchable(): bool
    {
        return $this->status === 'approved';
    }

    public function toSearchableArray(): array
    {
        return [
            'id' => $this->id,
            'public_id' => $this->public_id,
            'title' => $this->title,
            'type' => $this->type,
            'city' => $this->city,
            'state' => $this->state,
            'country' => $this->country,
            'price_per_night' => $this->price_per_night,
            'currency' => $this->currency,
            'amenities' => $this->amenities,
            'description' => $this->description,
        ];
    }

    public function registerMediaCollections(): void
    {
        $this
            ->addMediaCollection('gallery')
            ->useFallbackUrl(asset('images/placeholders/lodging.jpg'))
            ->useDisk(config('media-library.disk_name', config('filesystems.default', 'public')));
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        $this
            ->addMediaConversion('thumb')
            ->width(400)
            ->height(300)
            ->sharpen(10)
            ->format('webp')
            ->performOnCollections('gallery');

        $this
            ->addMediaConversion('preview')
            ->width(1280)
            ->height(720)
            ->format('webp')
            ->performOnCollections('gallery');
    }
}
