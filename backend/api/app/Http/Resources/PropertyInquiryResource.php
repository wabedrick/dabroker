<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\PropertyInquiryMessageResource;

/** @mixin \App\Models\PropertyInquiry */
class PropertyInquiryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'status' => $this->status,
            'message' => $this->message,
            'contact_method' => $this->contact_method,
            'contact_value' => $this->contact_value,
            'metadata' => $this->metadata,
            'read_at' => $this->read_at,
            'buyer_read_at' => $this->buyer_read_at,
            'responded_at' => $this->responded_at,
            'created_at' => $this->created_at,
            'property' => $this->whenLoaded('property', function (): array {
                return [
                    'id' => $this->property?->public_id,
                    'title' => $this->property?->title ?? 'Unknown Property',
                    'status' => $this->property?->status?->value,
                ];
            }),
            'sender' => $this->whenLoaded('sender', function (): array {
                return [
                    'id' => $this->sender?->id,
                    'name' => $this->sender?->name ?? 'Unknown User',
                    'preferred_role' => $this->sender?->preferred_role,
                ];
            }),
            'messages' => $this->whenLoaded('messages', function () {
                return PropertyInquiryMessageResource::collection($this->messages);
            }),
        ];
    }
}
