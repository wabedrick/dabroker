<?php

namespace App\Policies;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;

class PropertyPolicy
{
    public function view(User $user, Property $property): bool
    {
        return $property->owner_id === $user->id || $user->can('properties.approve');
    }

    public function update(User $user, Property $property): bool
    {
        if ($user->can('properties.approve')) {
            return true;
        }

        if ($property->status === PropertyStatus::Approved) {
            return false;
        }

        return $property->owner_id === $user->id;
    }

    public function delete(User $user, Property $property): bool
    {
        return $property->owner_id === $user->id || $user->can('properties.approve');
    }

    public function create(User $user): bool
    {
        return $user->can('properties.create');
    }

    public function approve(User $user): bool
    {
        return $user->can('properties.approve');
    }
}
