<?php

namespace Tests\Feature\Professional;

use App\Models\User;
use App\Models\ProfessionalProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class ProfessionalServicesTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Role::create(['name' => 'broker']);
        Role::create(['name' => 'user']);
    }

    public function test_user_can_apply_to_be_professional()
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user)->postJson('/api/v1/professionals/apply', [
            'license_number' => 'BRK-12345',
            'specialties' => ['residential', 'commercial'],
            'bio' => 'Experienced broker.',
            'hourly_rate' => 150.00,
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('professional_profiles', [
            'user_id' => $user->id,
            'license_number' => 'BRK-12345',
            'verification_status' => 'pending',
        ]);
    }

    public function test_user_can_book_consultation()
    {
        $user = User::factory()->create();
        $professional = User::factory()->create();
        ProfessionalProfile::create([
            'user_id' => $professional->id,
            'license_number' => '123',
            'bio' => 'Test',
            'hourly_rate' => 100,
            'verification_status' => 'verified',
        ]);

        $response = $this->actingAs($user)->postJson('/api/v1/consultations', [
            'professional_id' => $professional->id,
            'scheduled_at' => now()->addDay()->toDateTimeString(),
            'notes' => 'Need advice.',
        ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('consultations', [
            'user_id' => $user->id,
            'professional_id' => $professional->id,
            'status' => 'pending',
        ]);
    }
}
