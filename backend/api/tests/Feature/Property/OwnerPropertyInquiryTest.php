<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\PropertyInquiry;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OwnerPropertyInquiryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_owner_can_list_inquiries(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyerOne = User::factory()->create(['preferred_role' => 'buyer']);
        $buyerTwo = User::factory()->create(['preferred_role' => 'buyer']);

        PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyerOne->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer1@example.com',
            'message' => 'I want to schedule a tour.',
            'status' => 'open',
        ]);

        PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyerTwo->id,
            'contact_method' => 'phone',
            'contact_value' => '+1234567890',
            'message' => 'Is this still available?',
            'status' => 'open',
        ]);

        $response = $this->actingAs($owner, 'sanctum')
            ->getJson('/api/v1/owner/inquiries');

        $response->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.property.id', $property->public_id)
            ->assertJsonPath('data.0.sender.preferred_role', 'buyer');
    }

    public function test_owner_can_view_and_mark_inquiry_as_read(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        $inquiry = PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyer->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer@example.com',
            'message' => 'Please share more photos.',
            'status' => 'open',
        ]);

        $this->assertNull($inquiry->read_at);

        $response = $this->actingAs($owner, 'sanctum')
            ->getJson("/api/v1/owner/inquiries/{$inquiry->public_id}");

        $response->assertOk()
            ->assertJsonPath('data.id', $inquiry->public_id)
            ->assertJsonPath('data.read_at', fn($value) => ! is_null($value));

        $this->assertNotNull($inquiry->fresh()->read_at);
    }

    public function test_owner_cannot_view_inquiry_they_do_not_own(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $otherOwner = User::factory()->create(['preferred_role' => 'seller']);
        $otherOwner->assignRole('seller');

        $property = Property::factory()->for($otherOwner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        $inquiry = PropertyInquiry::create([
            'property_id' => $property->id,
            'owner_id' => $otherOwner->id,
            'sender_id' => $buyer->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer@example.com',
            'message' => 'Checking availability.',
            'status' => 'open',
        ]);

        $this->actingAs($owner, 'sanctum')
            ->getJson("/api/v1/owner/inquiries/{$inquiry->public_id}")
            ->assertForbidden();
    }
}
