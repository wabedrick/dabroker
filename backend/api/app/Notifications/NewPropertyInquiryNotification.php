<?php

namespace App\Notifications;

use App\Models\PropertyInquiry;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Str;

class NewPropertyInquiryNotification extends Notification
{
    use Queueable;

    public function __construct(private readonly PropertyInquiry $inquiry) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'inquiry_id' => $this->inquiry->public_id,
            'property_id' => $this->inquiry->property?->public_id,
            'property_title' => $this->inquiry->property?->title,
            'message_preview' => Str::limit($this->inquiry->message, 120),
            'contact_method' => $this->inquiry->contact_method,
            'contact_value' => $this->inquiry->contact_value,
            'sender_id' => $this->inquiry->sender_id,
        ];
    }
}
