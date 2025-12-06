<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class PropertySearchTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config(['scout.driver' => 'database']);
    }

    public function test_public_endpoint_only_returns_approved_properties(): void
    {
        $approved = Property::factory()->create([
            'status' => PropertyStatus::Approved,
            'city' => 'Kampala',
            'price' => 120000,
        ]);

        Property::factory()->create([
            'status' => PropertyStatus::Pending,
            'city' => 'Nairobi',
        ]);

        $response = $this->getJson('/api/v1/properties');

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $approved->public_id);
    }

    public function test_public_endpoint_supports_search_and_filters(): void
    {
        Property::factory()->create([
            'title' => 'Lake View Villa',
            'city' => 'Kampala',
            'country' => 'Uganda',
            'price' => 250000,
            'type' => 'house',
        ]);

        Property::factory()->create([
            'title' => 'Downtown Plot',
            'city' => 'Kampala',
            'country' => 'Uganda',
            'price' => 450000,
            'type' => 'land',
        ]);

        $response = $this->getJson('/api/v1/properties?q=villa&city=Kampala&price_max=300000&type=house');

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.title', 'Lake View Villa');
    }

    public function test_property_detail_endpoint_includes_gallery_and_rejects_pending_records(): void
    {
        Storage::fake('public');

        $approved = Property::factory()->create([
            'status' => PropertyStatus::Approved,
        ]);

        $approved
            ->addMedia($this->fakeImage('front.jpg'))
            ->toMediaCollection('gallery');

        $response = $this->getJson("/api/v1/properties/{$approved->public_id}");

        $response->assertOk()
            ->assertJsonPath('data.gallery.0.name', 'front');

        $pending = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        $this->getJson("/api/v1/properties/{$pending->public_id}")
            ->assertNotFound();
    }

    public function test_authenticated_user_sees_favorite_flag_on_browse_and_detail(): void
    {
        $user = User::factory()->create(['preferred_role' => 'buyer']);

        $property = Property::factory()->create([
            'status' => PropertyStatus::Approved,
        ]);

        $user->favoriteProperties()->attach($property->id);

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/v1/properties')
            ->assertOk()
            ->assertJsonPath('data.0.is_favorited', true);

        $this->actingAs($user, 'sanctum')
            ->getJson("/api/v1/properties/{$property->public_id}")
            ->assertOk()
            ->assertJsonPath('data.is_favorited', true);
    }

    private function fakeImage(string $name = 'photo.jpg'): UploadedFile
    {
        $pixel = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=');

        return UploadedFile::fake()->createWithContent($name, $pixel);
    }
}
