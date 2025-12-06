<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Events\PropertyInquiryMessageCreated;
use App\Models\Property;
use App\Models\PropertyInquiry;
use App\Models\User;
use App\Notifications\NewPropertyInquiryNotification;
use App\Notifications\PropertyInquiryReplyNotification;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Notification;
use Tests\TestCase;

class PropertyInquiryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
        Notification::fake();
    }

    public function test_buyer_can_contact_owner_of_approved_property(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $payload = [
            'message' => 'I would like to schedule a viewing next week.',
            'contact_method' => 'email',
            'contact_value' => 'buyer@example.com',
        ];

        $response = $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", $payload);

        $response->assertCreated()
            ->assertJsonPath('message', 'Inquiry sent to property owner.');

        $this->assertDatabaseHas('property_inquiries', [
            'owner_id' => $owner->id,
            'sender_id' => $buyer->id,
            'property_id' => $property->id,
        ]);

        Notification::assertSentTo($owner, NewPropertyInquiryNotification::class);
    }

    public function test_owner_cannot_contact_their_own_property(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Owner trying to contact own listing.',
            ])
            ->assertStatus(422);
    }

    public function test_cannot_contact_pending_property(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Pending,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Interested buyer awaiting approval.',
            ])
            ->assertStatus(422);
    }

    public function test_owner_and_buyer_can_exchange_messages(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Initial outreach.',
            ])
            ->assertCreated();

        $inquiry = PropertyInquiry::first();

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'Thanks for reaching out!'
            ])
            ->assertCreated()
            ->assertJsonPath('data.message', 'Thanks for reaching out!');

        $inquiry->refresh();

        $this->assertNotNull($inquiry->responded_at);
        $this->assertEquals(PropertyInquiry::STATUS_RESPONDED, $inquiry->status);
        $this->assertNull($inquiry->buyer_read_at);

        Notification::assertSentTo($buyer, PropertyInquiryReplyNotification::class);

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'Great, looking forward to it.'
            ])
            ->assertCreated();

        $inquiry->refresh();

        $this->assertNull($inquiry->read_at);
        $this->assertEquals(PropertyInquiry::STATUS_OPEN, $inquiry->status);
        $this->assertNotNull($inquiry->buyer_read_at);

        Notification::assertSentTo($owner, PropertyInquiryReplyNotification::class);

        $this->assertDatabaseCount('property_inquiry_messages', 3);
    }

    public function test_other_users_cannot_reply_to_inquiry(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Initial outreach.',
            ])
            ->assertCreated();

        $inquiry = PropertyInquiry::first();

        $stranger = User::factory()->create();

        $this->actingAs($stranger, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'Bad actor reply',
            ])
            ->assertForbidden();
    }

    public function test_message_creation_dispatches_broadcast_event(): void
    {
        Event::fake([PropertyInquiryMessageCreated::class]);

        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);
        $buyer->assignRole('buyer');

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Initial outreach.',
            ])
            ->assertCreated();

        $inquiry = PropertyInquiry::first();

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'Broadcast check'
            ])
            ->assertCreated();

        Event::assertDispatched(PropertyInquiryMessageCreated::class, function ($event) use ($inquiry) {
            return $event->inquiry->is($inquiry)
                && $event->message->message === 'Broadcast check';
        });
    }

    public function test_reply_notification_respects_email_preferences(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');
        $owner->givePermissionTo('messaging.initiate');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create([
            'preferred_role' => 'buyer',
            'notification_preferences' => [
                'inquiries' => ['push' => true, 'email' => true],
                'favorites' => ['push' => true, 'email' => false],
            ],
        ]);
        $buyer->assignRole('buyer');

        $this->actingAs($buyer, 'sanctum')
            ->postJson("/api/v1/properties/{$property->public_id}/contact", [
                'message' => 'Initial outreach.',
            ])
            ->assertCreated();

        $inquiry = PropertyInquiry::first();

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'First follow up'
            ])
            ->assertCreated();

        Notification::assertSentTo($buyer, PropertyInquiryReplyNotification::class, function ($notification, $channels) {
            $this->assertContains('database', $channels);
            $this->assertContains('mail', $channels);
            $this->assertContains('broadcast', $channels);

            return true;
        });

        Notification::fake();

        $buyer->forceFill([
            'notification_preferences' => [
                'inquiries' => ['push' => true, 'email' => false],
                'favorites' => ['push' => true, 'email' => false],
            ],
        ])->save();

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/inquiries/{$inquiry->public_id}/messages", [
                'message' => 'Second follow up'
            ])
            ->assertCreated();

        Notification::assertSentTo($buyer, PropertyInquiryReplyNotification::class, function ($notification, $channels) {
            $this->assertContains('database', $channels);
            $this->assertContains('broadcast', $channels);
            $this->assertNotContains('mail', $channels);

            return true;
        });
    }
}
