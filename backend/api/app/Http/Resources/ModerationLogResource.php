<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\ModerationLog */
class ModerationLogResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'action' => $this->action,
            'entity' => [
                'type' => class_basename($this->moderatable_type),
                'internal_id' => $this->moderatable_id,
                'public_id' => $this->moderatable_public_id,
            ],
            'previous_status' => $this->previous_status,
            'new_status' => $this->new_status,
            'reason' => $this->reason,
            'old_values' => $this->old_values ?? [],
            'new_values' => $this->new_values ?? [],
            'meta' => $this->meta ?? [],
            'performed_by' => new UserResource($this->whenLoaded('performedBy')),
            'created_at' => $this->created_at,
        ];
    }
}
