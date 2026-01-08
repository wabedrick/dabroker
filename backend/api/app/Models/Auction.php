<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class Auction extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'public_id',
        'property_id',
        'seller_id',
        'start_time',
        'end_time',
        'starting_price',
        'reserve_price',
        'current_price',
        'status',
        'winning_bid_id',
    ];

    protected $casts = [
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'starting_price' => 'decimal:2',
        'reserve_price' => 'decimal:2',
        'current_price' => 'decimal:2',
    ];

    protected static function booted(): void
    {
        static::creating(function (Auction $auction): void {
            $auction->public_id ??= (string) Str::uuid();
        });
    }

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function seller()
    {
        return $this->belongsTo(User::class, 'seller_id');
    }

    public function bids()
    {
        return $this->hasMany(Bid::class);
    }

    public function highestBid()
    {
        return $this->hasOne(Bid::class)->latest('amount');
    }
}
