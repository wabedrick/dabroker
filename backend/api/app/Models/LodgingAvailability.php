<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LodgingAvailability extends Model
{
    use HasFactory;

    protected $table = 'lodging_availability';

    protected $fillable = [
        'lodging_id',
        'date',
        'is_available',
        'price_override',
    ];

    protected $casts = [
        'date' => 'date',
        'is_available' => 'boolean',
        'price_override' => 'decimal:2',
    ];

    public function lodging(): BelongsTo
    {
        return $this->belongsTo(Lodging::class);
    }
}
