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
            'country_code' => $this->country_code,
            'status' => $this->status,
            'preferred_role' => $this->preferred_role,
            'roles' => $this->getRoleNames()->values()->all(),
            'permissions' => $this->getPermissionNames()->values()->all(),
            'email_verified_at' => $this->email_verified_at,
            'phone_verified_at' => $this->phone_verified_at,
            'last_login_at' => $this->whenHas('last_login_at', fn () => $this->last_login_at),
            'bio' => $this->bio,
            'metadata' => $this->metadata,
            'professional_profile' => $this->whenLoaded('professionalProfile', function () {
                return [
                    'id' => $this->professionalProfile->id,
                    'user_id' => $this->professionalProfile->user_id,
                    'license_number' => $this->professionalProfile->license_number,
                    'specialties' => $this->professionalProfile->specialties,
                    'bio' => $this->professionalProfile->bio,
                    'hourly_rate' => (float) $this->professionalProfile->hourly_rate,
                    'verification_status' => $this->professionalProfile->verification_status,
                    'created_at' => $this->professionalProfile->created_at->toIso8601String(),
                    'updated_at' => $this->professionalProfile->updated_at->toIso8601String(),
                ];
            }),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
