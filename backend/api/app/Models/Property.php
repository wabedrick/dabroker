<?php

namespace App\Models;

use App\Enums\PropertyStatus;
use App\Models\Pivots\PropertyFavoritePivot;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;
use Laravel\Scout\Searchable;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Property extends Model implements HasMedia
{
    use HasFactory;
    use InteractsWithMedia;
    use Searchable;
    use SoftDeletes;

    protected $fillable = [
        'public_id',
        'owner_id',
        'title',
        'slug',
        'type',
        'category',
        'status',
        'is_available',
        'price',
        'currency',
        'size',
        'size_unit',
        'house_age',
        'address',
        'city',
        'state',
        'country',
        'postal_code',
        'latitude',
        'longitude',
        'amenities',
        'metadata',
        'description',
        'published_at',
        'approved_at',
        'approved_by',
        'rejection_reason',
        'available_from',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'size' => 'decimal:2',
        'house_age' => 'integer',
        'latitude' => 'decimal:7',
        'longitude' => 'decimal:7',
        'amenities' => 'array',
        'metadata' => 'array',
        'published_at' => 'datetime',
        'approved_at' => 'datetime',
        'available_from' => 'datetime',
        'status' => PropertyStatus::class,
        'is_available' => 'boolean',
    ];

    protected static function booted(): void
    {
        static::creating(function (Property $property): void {
            $property->public_id ??= (string) Str::uuid();
            $property->slug ??= Str::slug(Str::limit($property->title, 60) . '-' . Str::random(6));
        });
    }

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function favoritedBy(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'property_favorites')
            ->using(PropertyFavoritePivot::class)
            ->withPivot(['public_id', 'owner_id', 'owner_read_at'])
            ->withTimestamps();
    }

    public function inquiries()
    {
        return $this->hasMany(PropertyInquiry::class);
    }

    public function shouldBeSearchable(): bool
    {
        return $this->resolveStatusEnum() === PropertyStatus::Approved;
    }

    public function toSearchableArray(): array
    {
        $status = $this->resolveStatusEnum();

        return [
            'id' => $this->id,
            'public_id' => $this->public_id,
            'title' => $this->title,
            'type' => $this->type,
            'category' => $this->category,
            'city' => $this->city,
            'state' => $this->state,
            'country' => $this->country,
            'price' => $this->price,
            'currency' => $this->currency,
            'status' => $status?->value ?? $this->status,
            'amenities' => $this->amenities,
            'description' => $this->description,
        ];
    }

    public function registerMediaCollections(): void
    {
        $collection = $this
            ->addMediaCollection('gallery')
            ->useFallbackUrl(asset('images/placeholders/property.jpg'))
            ->useDisk(config('media-library.disk_name', config('filesystems.default', 'public')));

        if ($this->canProcessImages()) {
            $collection->withResponsiveImages();
        }
    }

    public function registerMediaConversions(?Media $media = null): void
    {
        if (! $this->canProcessImages()) {
            return;
        }

        $this
            ->addMediaConversion('thumb')
            ->width(320)
            ->height(240)
            ->format('webp')
            ->performOnCollections('gallery');

        $this
            ->addMediaConversion('preview')
            ->width(1280)
            ->height(720)
            ->format('webp')
            ->performOnCollections('gallery');
    }

    public function getRouteKeyName(): string
    {
        return 'public_id';
    }

    public function scopeApproved(Builder $query): Builder
    {
        return $query->where('status', PropertyStatus::Approved);
    }

    private function resolveStatusEnum(): ?PropertyStatus
    {
        if ($this->status instanceof PropertyStatus) {
            return $this->status;
        }

        if (is_string($this->status)) {
            return PropertyStatus::tryFrom($this->status);
        }

        return null;
    }

    private function canProcessImages(): bool
    {
        return extension_loaded('gd') || extension_loaded('imagick');
    }
}
