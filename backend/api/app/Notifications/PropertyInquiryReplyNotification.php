<?php

namespace App\Notifications;

use App\Models\PropertyInquiry;
use App\Models\PropertyInquiryMessage;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Str;

class PropertyInquiryReplyNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        private readonly PropertyInquiry $inquiry,
        private readonly PropertyInquiryMessage $message
    ) {}

    public function via(object $notifiable): array
    {
        $channels = ['database'];

        if ($notifiable->notificationPreference('inquiries.email', true)) {
            $channels[] = 'mail';
        }

        if ($notifiable->notificationPreference('inquiries.push', true)) {
            $channels[] = 'broadcast';
        }

        return $channels;
    }

    public function toMail(object $notifiable): MailMessage
    {
        $url = rtrim(config('app.frontend_url', config('app.url')), '/') . '/inquiries/' . $this->inquiry->public_id;

        $subject = $this->inquiry->property
            ? 'New reply on your inquiry about ' . $this->inquiry->property->title
            : 'New reply on your professional inquiry';

        $line = $this->inquiry->property
            ? 'You have a new message about "' . $this->inquiry->property->title . '".'
            : 'You have a new message in your professional inquiry.';

        return (new MailMessage())
            ->subject($subject)
            ->greeting('Hello ' . $notifiable->name . ',')
            ->line($line)
            ->line('"' . Str::limit($this->message->message, 160) . '"')
            ->action('View conversation', $url)
            ->line('Reply to keep the conversation going.');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'inquiry_id' => $this->inquiry->public_id,
            'message_id' => $this->message->public_id,
            'property_id' => $this->inquiry->property?->public_id,
            'property_title' => $this->inquiry->property?->title,
            'sender_id' => $this->message->sender_id,
            'sender_name' => $this->message->sender?->name,
            'message_preview' => Str::limit($this->message->message, 160),
        ];
    }

    public function toBroadcast(object $notifiable): BroadcastMessage
    {
        return new BroadcastMessage($this->toArray($notifiable) + [
            'type' => 'property_inquiry.reply',
            'notifiable_id' => $notifiable->id,
        ]);
    }
}
