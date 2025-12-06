<?php

namespace Tests\Feature\Property;

use App\Enums\PropertyStatus;
use App\Models\Property;
use App\Models\User;
use Database\Seeders\BasePermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class PropertyMediaTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(BasePermissionsSeeder::class);
        Storage::fake('public');
    }

    public function test_owner_can_upload_gallery_media(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Pending,
        ]);

        $response = $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/owner/properties/{$property->public_id}/media", [
                'file' => $this->fakeImage('kitchen.jpg'),
                'caption' => 'Modern kitchen',
            ]);

        $response->assertCreated()
            ->assertJsonPath('data.caption', 'Modern kitchen');

        $this->assertCount(1, $property->fresh()->getMedia('gallery'));
    }

    public function test_owner_cannot_upload_media_for_foreign_property(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $otherProperty = Property::factory()->create([
            'status' => PropertyStatus::Pending,
        ]);

        $this->actingAs($owner, 'sanctum')
            ->postJson("/api/v1/owner/properties/{$otherProperty->public_id}/media", [
                'file' => $this->fakeImage('intruder.jpg'),
            ])
            ->assertForbidden();
    }

    public function test_owner_can_delete_gallery_media(): void
    {
        $owner = User::factory()->create(['preferred_role' => 'seller']);
        $owner->assignRole('seller');

        $property = Property::factory()->for($owner, 'owner')->create([
            'status' => PropertyStatus::Pending,
        ]);

        $media = $property
            ->addMedia($this->fakeImage('pool.jpg'))
            ->toMediaCollection('gallery');

        $this->actingAs($owner, 'sanctum')
            ->deleteJson("/api/v1/owner/properties/{$property->public_id}/media/{$media->uuid}")
            ->assertOk()
            ->assertJson(['message' => 'Media removed from gallery.']);

        $this->assertCount(0, $property->fresh()->getMedia('gallery'));
    }

    private function fakeImage(string $name = 'photo.jpg'): UploadedFile
    {
        $pixel = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=');

        return UploadedFile::fake()->createWithContent($name, $pixel);
    }
}
