<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class ProfessionalPortfolio extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'professional_profile_id',
        'title',
        'description',
        'project_date',
        'url',
    ];

    protected $casts = [
        'project_date' => 'date',
    ];

    public function professionalProfile()
    {
        return $this->belongsTo(ProfessionalProfile::class);
    }

    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('portfolio_images')
            ->useDisk('public');
    }
}
