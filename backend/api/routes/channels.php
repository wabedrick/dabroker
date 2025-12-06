<?php

use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('users.{userId}', function ($user, int $userId) {
    if ((int) $user->id !== $userId) {
        return false;
    }

    return [
        'id' => $user->id,
        'name' => $user->name,
        'preferred_role' => $user->preferred_role,
    ];
});
