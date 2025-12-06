<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\PropertyInquiryMessage */
class PropertyInquiryMessageResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'public_id' => $this->public_id,
            'sender_id' => $this->sender_id,
            'message' => $this->message,
            'metadata' => $this->metadata,
            'created_at' => $this->created_at->toIso8601String(),
            'sender' => [
                'id' => $this->sender->id,
                'name' => $this->sender->name,
                'preferred_role' => $this->sender->preferred_role ?? 'user',
            ],
        ];
    }
}
