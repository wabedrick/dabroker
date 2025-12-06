<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use App\Services\OtpService;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
    }

    public function test_user_can_register_and_receives_pending_status(): void
    {
        Cache::spy();

        $payload = [
            'name' => 'Alice Agent',
            'email' => 'alice@example.com',
            'phone' => '+256700000001',
            'country_code' => '+256',
            'password' => 'SuperSecure#123',
            'password_confirmation' => 'SuperSecure#123',
            'preferred_role' => 'buyer',
        ];

        $response = $this->postJson('/api/v1/auth/register', $payload);

        $response->assertCreated()
            ->assertJsonPath('data.status', 'pending')
            ->assertJsonPath('data.preferred_role', 'buyer');

        $this->assertDatabaseHas('users', [
            'email' => 'alice@example.com',
            'status' => 'pending',
        ]);
    }

    public function test_registration_skips_otp_when_disabled(): void
    {
        config()->set('otp.enabled', false);

        $payload = [
            'name' => 'Bob Builder',
            'email' => 'bob@example.com',
            'phone' => '+256700000099',
            'country_code' => '+256',
            'password' => 'SuperSecure#123',
            'password_confirmation' => 'SuperSecure#123',
            'preferred_role' => 'buyer',
        ];

        $response = $this->postJson('/api/v1/auth/register', $payload);

        $response->assertCreated()
            ->assertJsonPath('data.status', 'active');

        $this->assertDatabaseHas('users', [
            'email' => 'bob@example.com',
            'status' => 'active',
        ]);
    }

    public function test_user_can_login_with_email(): void
    {
        $user = User::factory()->create([
            'email' => 'agent@example.com',
            'phone' => '+256700000010',
            'preferred_role' => 'buyer',
        ]);

        $user->assignRole('buyer');

        $response = $this->postJson('/api/v1/auth/login', [
            'identifier' => 'agent@example.com',
            'password' => 'password',
            'device_name' => 'pixel',
        ]);

        $response->assertOk()
            ->assertJsonStructure(['token', 'data' => ['id', 'email']]);

        $this->assertNotNull($user->fresh()->last_login_at);
    }

    public function test_pending_user_auto_activates_on_login_when_otp_disabled(): void
    {
        config()->set('otp.enabled', false);

        $user = User::factory()->create([
            'email' => 'pending@example.com',
            'phone' => '+256700000011',
            'status' => 'pending',
        ]);

        $user->assignRole('buyer');

        $response = $this->postJson('/api/v1/auth/login', [
            'identifier' => 'pending@example.com',
            'password' => 'password',
            'device_name' => 'pixel',
        ]);

        $response->assertOk()
            ->assertJsonStructure(['token']);

        $this->assertSame('active', $user->fresh()->status);
    }

    public function test_user_can_request_password_reset_otp(): void
    {
        $user = User::factory()->create([
            'email' => 'reset@example.com',
            'phone' => '+256700000020',
        ]);

        $response = $this->postJson('/api/v1/auth/password/forgot', [
            'identifier' => 'reset@example.com',
        ]);

        $response->assertOk()
            ->assertJson(['message' => 'OTP sent to the provided identifier.']);
    }

    public function test_user_can_resend_registration_otp(): void
    {
        Cache::spy();

        $user = User::factory()->create([
            'email' => 'pending@example.com',
            'phone' => '+256700000021',
            'status' => 'pending',
        ]);

        $response = $this->postJson('/api/v1/auth/resend-otp', [
            'identifier' => $user->email,
            'purpose' => 'registration',
        ]);

        $response->assertOk()
            ->assertJson(['message' => 'OTP resent successfully.']);

        Cache::shouldHaveReceived('put')->once();
    }

    public function test_resend_otp_returns_noop_when_disabled(): void
    {
        config()->set('otp.enabled', false);

        $user = User::factory()->create([
            'email' => 'noop@example.com',
            'phone' => '+256700000022',
            'status' => 'pending',
        ]);

        $response = $this->postJson('/api/v1/auth/resend-otp', [
            'identifier' => $user->email,
            'purpose' => 'registration',
        ]);

        $response->assertOk()
            ->assertJson(['message' => 'OTP verification is currently disabled.']);

        $this->assertSame('active', $user->fresh()->status);
    }

    public function test_resend_otp_requires_existing_user(): void
    {
        $response = $this->postJson('/api/v1/auth/resend-otp', [
            'identifier' => 'unknown@example.com',
            'purpose' => 'registration',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['identifier']);
    }

    public function test_user_can_reset_password_with_valid_otp(): void
    {
        $user = User::factory()->create([
            'email' => 'recover@example.com',
            'phone' => '+256700000030',
            'password' => Hash::make('OldPassword#123'),
        ]);

        $otp = app(OtpService::class)->send('recover@example.com', 'password_reset');

        $response = $this->postJson('/api/v1/auth/password/reset', [
            'identifier' => 'recover@example.com',
            'otp' => $otp,
            'password' => 'NewPassword#456',
            'password_confirmation' => 'NewPassword#456',
        ]);

        $response->assertOk()
            ->assertJson(['message' => 'Password reset successful.']);

        $this->assertTrue(Hash::check('NewPassword#456', $user->fresh()->password));
    }
}
