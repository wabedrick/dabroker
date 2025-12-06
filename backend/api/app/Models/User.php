<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Models\Property;
use App\Models\PropertyInquiry;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use App\Models\Pivots\PropertyFavoritePivot;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, HasRoles, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'phone',
        'country_code',
        'password',
        'status',
        'preferred_role',
        'bio',
        'metadata',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'phone_verified_at' => 'datetime',
            'last_login_at' => 'datetime',
            'password' => 'hashed',
            'metadata' => 'array',
            'notification_preferences' => 'array',
        ];
    }

    public function notificationPreferences(): array
    {
        return array_replace_recursive($this->defaultNotificationPreferences(), $this->notification_preferences ?? []);
    }

    public function notificationPreference(string $key, mixed $default = null): mixed
    {
        return data_get($this->notificationPreferences(), $key, $default);
    }

    private function defaultNotificationPreferences(): array
    {
        return [
            'inquiries' => [
                'push' => true,
                'email' => true,
            ],
            'favorites' => [
                'push' => true,
                'email' => false,
            ],
        ];
    }

    public function properties()
    {
        return $this->hasMany(Property::class, 'owner_id');
    }

    public function lodgings()
    {
        return $this->hasMany(Lodging::class, 'host_id');
    }

    public function favoriteProperties(): BelongsToMany
    {
        return $this->belongsToMany(Property::class, 'property_favorites')
            ->using(PropertyFavoritePivot::class)
            ->withPivot(['public_id', 'owner_id', 'owner_read_at'])
            ->withTimestamps();
    }

    public function hasFavorited(Property $property): bool
    {
        if ($this->relationLoaded('favoriteProperties')) {
            return $this->favoriteProperties->contains('id', $property->id);
        }

        return $this->favoriteProperties()
            ->where('properties.id', $property->id)
            ->exists();
    }

    public function receivedPropertyInquiries()
    {
        return $this->hasMany(PropertyInquiry::class, 'owner_id');
    }

    public function sentPropertyInquiries()
    {
        return $this->hasMany(PropertyInquiry::class, 'sender_id');
    }

    public function professionalProfile()
    {
        return $this->hasOne(ProfessionalProfile::class);
    }
}
