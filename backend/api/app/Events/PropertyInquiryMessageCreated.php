<?php

namespace App\Events;

use App\Models\PropertyInquiry;
use App\Models\PropertyInquiryMessage;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class PropertyInquiryMessageCreated implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public PropertyInquiry $inquiry,
        public PropertyInquiryMessage $message
    ) {
        $this->message->loadMissing('sender:id,name,preferred_role');
    }

    public function broadcastOn(): array
    {
        return [
            new PrivateChannel('users.' . $this->inquiry->owner_id),
            new PrivateChannel('users.' . $this->inquiry->sender_id),
        ];
    }

    public function broadcastAs(): string
    {
        return 'property-inquiry.message-created';
    }

    public function broadcastWith(): array
    {
        return [
            'inquiry' => [
                'id' => $this->inquiry->public_id,
                'status' => $this->inquiry->status,
                'read_at' => $this->inquiry->read_at?->toISOString(),
                'buyer_read_at' => $this->inquiry->buyer_read_at?->toISOString(),
            ],
            'message' => [
                'id' => $this->message->public_id,
                'message' => $this->message->message,
                'metadata' => $this->message->metadata,
                'created_at' => $this->message->created_at?->toISOString(),
                'sender' => [
                    'id' => $this->message->sender->id,
                    'name' => $this->message->sender->name,
                    'preferred_role' => $this->message->sender->preferred_role,
                ],
            ],
        ];
    }
}
