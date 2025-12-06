<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\PropertyFavorite;
use App\Models\PropertyInquiry;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class OwnerDashboardTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_owner_receives_dashboard_summary(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $approved = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Approved,
        ]);

        $pending = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Pending,
        ]);

        $rejected = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Rejected,
        ]);

        $buyer = User::factory()->create(['preferred_role' => 'buyer']);

        PropertyInquiry::create([
            'property_id' => $approved->id,
            'owner_id' => $owner->id,
            'sender_id' => $buyer->id,
            'contact_method' => 'email',
            'contact_value' => 'buyer@example.com',
            'message' => 'Dashboard inquiry.',
            'status' => 'open',
        ]);

        PropertyFavorite::create([
            'user_id' => $buyer->id,
            'property_id' => $approved->id,
            'owner_id' => $owner->id,
        ]);

        $response = $this->actingAs($owner, 'sanctum')
            ->getJson('/api/v1/owner/dashboard');

        $response->assertOk()
            ->assertJsonPath('data.counts.total', 3)
            ->assertJsonPath('data.counts.pending', 1)
            ->assertJsonPath('data.notifications.unread_inquiries', 1)
            ->assertJsonPath('data.notifications.buyer_unread_inquiries', 0)
            ->assertJsonPath('data.recent_inquiries.0.property.id', $approved->public_id)
            ->assertJsonPath('data.recent_interested_buyers.0.property.id', $approved->public_id);
    }
}
