<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class PropertyInquiryMessage extends Model
{
    use HasFactory;

    protected $fillable = [
        'public_id',
        'property_inquiry_id',
        'sender_id',
        'message',
        'metadata',
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    protected static function booted(): void
    {
        static::creating(function (PropertyInquiryMessage $message): void {
            $message->public_id ??= (string) Str::uuid();
        });
    }

    public function inquiry()
    {
        return $this->belongsTo(PropertyInquiry::class, 'property_inquiry_id');
    }

    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id');
    }
}
