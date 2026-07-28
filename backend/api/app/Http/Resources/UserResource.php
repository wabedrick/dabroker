<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Models\User */
class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'avatar' => $this->getFirstMediaUrl('avatar'),
            'country_code' => $this->country_code,
            'status' => $this->status,
            'preferred_role' => $this->preferred_role,
            'roles' => $this->getRoleNames()->values()->all(),
            'permissions' => $this->getPermissionNames()->values()->all(),
            'email_verified_at' => $this->email_verified_at,
            'phone_verified_at' => $this->phone_verified_at,
            'last_login_at' => $this->whenHas('last_login_at', fn() => $this->last_login_at),
            'bio' => $this->bio,
            'metadata' => $this->metadata,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'average_rating' => $this->averageRating(),
            'ratings_count' => $this->ratingsCount(),
        ];
    }
}
