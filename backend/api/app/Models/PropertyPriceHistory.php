<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PropertyPriceHistory extends Model
{
    protected $fillable = [
        'property_id',
        'old_price',
        'new_price',
        'changed_at',
    ];

    protected $casts = [
        'old_price' => 'decimal:2',
        'new_price' => 'decimal:2',
        'changed_at' => 'datetime',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}
