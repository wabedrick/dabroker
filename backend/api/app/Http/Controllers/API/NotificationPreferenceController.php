<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Notification\UpdateNotificationPreferenceRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationPreferenceController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json([
            'data' => $this->mergePreferences($request->user()),
        ]);
    }

    public function update(UpdateNotificationPreferenceRequest $request): JsonResponse
    {
        $user = $request->user();
        $preferences = $this->mergePreferences($user, $request->validated());

        $user->forceFill(['notification_preferences' => $preferences])->save();

        return response()->json([
            'message' => 'Notification preferences updated.',
            'data' => $preferences,
        ]);
    }

    private function mergePreferences(User $user, array $overrides = []): array
    {
        return array_replace_recursive(
            $this->defaultPreferences(),
            $user->notification_preferences ?? [],
            $overrides,
        );
    }

    private function defaultPreferences(): array
    {
        return [
            'inquiries' => [
                'push' => true,
                'email' => true,
            ],
            'favorites' => [
                'push' => true,
                'email' => false,
            ],
        ];
    }
}
