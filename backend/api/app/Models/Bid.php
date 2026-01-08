<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Bid extends Model
{
    protected $fillable = [
        'public_id',
        'auction_id',
        'user_id',
        'amount',
        'ip_address',
        'user_agent',
    ];

    protected $casts = [
        'amount' => 'decimal:2',
    ];

    protected static function booted(): void
    {
        static::creating(function (Bid $bid): void {
            $bid->public_id ??= (string) Str::uuid();
        });
    }

    public function auction()
    {
        return $this->belongsTo(Auction::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
