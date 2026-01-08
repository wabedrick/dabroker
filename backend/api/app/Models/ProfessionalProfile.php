<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProfessionalProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'license_number',
        'specialties',
        'bio',
        'hourly_rate',
        'experience_years',
        'languages',
        'education',
        'certifications',
        'social_links',
        'is_available',
        'verification_status',
    ];

    protected $casts = [
        'specialties' => 'array',
        'languages' => 'array',
        'education' => 'array',
        'certifications' => 'array',
        'social_links' => 'array',
        'hourly_rate' => 'decimal:2',
        'is_available' => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function portfolios()
    {
        return $this->hasMany(ProfessionalPortfolio::class);
    }
}
