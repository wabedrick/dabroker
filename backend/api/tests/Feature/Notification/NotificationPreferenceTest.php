<?php

namespace Tests\Feature\Notification;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotificationPreferenceTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_receives_default_preferences(): void
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/v1/notifications/preferences')
            ->assertOk()
            ->assertJsonPath('data.inquiries.push', true)
            ->assertJsonPath('data.favorites.email', false);
    }

    public function test_user_can_update_notification_preferences(): void
    {
        $user = User::factory()->create();

        $payload = [
            'inquiries' => ['email' => false],
            'favorites' => ['push' => false, 'email' => true],
        ];

        $this->actingAs($user, 'sanctum')
            ->putJson('/api/v1/notifications/preferences', $payload)
            ->assertOk()
            ->assertJsonPath('message', 'Notification preferences updated.')
            ->assertJsonPath('data.inquiries.email', false)
            ->assertJsonPath('data.favorites.email', true)
            ->assertJsonPath('data.favorites.push', false);

        $this->assertSame($payload['favorites']['email'], $user->fresh()->notification_preferences['favorites']['email']);
    }
}
