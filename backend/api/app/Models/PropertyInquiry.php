<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PropertyInquiry extends Model
{
    use HasFactory;

    public const STATUS_OPEN = 'open';
    public const STATUS_RESPONDED = 'responded';
    public const STATUS_CLOSED = 'closed';

    protected $fillable = [
        'public_id',
        'property_id',
        'booking_id',
        'owner_id',
        'sender_id',
        'contact_method',
        'contact_value',
        'status',
        'responded_at',
        'read_at',
        'buyer_read_at',
        'metadata',
        'message',
    ];

    protected $casts = [
        'metadata' => 'array',
        'responded_at' => 'datetime',
        'read_at' => 'datetime',
        'buyer_read_at' => 'datetime',
    ];

    public function getRouteKeyName(): string
    {
        return 'public_id';
    }

    protected static function booted(): void
    {
        static::creating(function (PropertyInquiry $inquiry): void {
            $inquiry->public_id ??= (string) Str::uuid();
        });
    }

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id');
    }

    public function messages()
    {
        return $this->hasMany(PropertyInquiryMessage::class, 'property_inquiry_id')
            ->with('sender:id,name,preferred_role')
            ->orderBy('created_at');
    }
}
