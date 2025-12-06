<?php

namespace App\Notifications;

use App\Models\Booking;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class BookingStatusChangedNotification extends Notification
{
    use Queueable;

    public function __construct(private readonly Booking $booking) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'booking_id' => $this->booking->public_id,
            'lodging_title' => $this->booking->lodging->title,
            'status' => $this->booking->status,
            'check_in' => $this->booking->check_in->toDateString(),
            'check_out' => $this->booking->check_out->toDateString(),
            'message' => "Your booking for {$this->booking->lodging->title} has been {$this->booking->status}.",
        ];
    }
}
