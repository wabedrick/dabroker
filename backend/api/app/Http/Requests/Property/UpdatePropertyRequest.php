<?php

namespace App\Http\Requests\Property;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePropertyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        // $propertyTypes = ['land', 'house'];

        return [
            'title' => ['sometimes', 'required', 'string', 'max:150'],
            'type' => ['sometimes', 'required', 'string', 'max:50'],
            'category' => ['sometimes', 'nullable', 'string', 'max:120'],
            'price' => ['sometimes', 'nullable', 'numeric', 'min:0'],
            'currency' => ['sometimes', 'required', 'string', 'size:3'],
            'size' => ['sometimes', 'nullable', 'numeric', 'min:0'],
            'size_unit' => ['sometimes', 'nullable', 'string', 'max:20'],
            'house_age' => ['sometimes', 'nullable', 'integer', 'min:0', 'max:200'],
            'address' => ['sometimes', 'nullable', 'string', 'max:255'],
            'city' => ['sometimes', 'required', 'string', 'max:120'],
            'state' => ['sometimes', 'nullable', 'string', 'max:120'],
            'country' => ['sometimes', 'required', 'string', 'max:120'],
            'postal_code' => ['sometimes', 'nullable', 'string', 'max:20'],
            'latitude' => ['sometimes', 'nullable', 'numeric', 'between:-90,90'],
            'longitude' => ['sometimes', 'nullable', 'numeric', 'between:-180,180'],
            'amenities' => ['sometimes', 'nullable', 'array'],
            'amenities.*' => ['string', 'max:50'],
            'metadata' => ['sometimes', 'nullable', 'array'],
            'description' => ['sometimes', 'nullable', 'string'],
            'available_from' => ['sometimes', 'nullable', 'date'],
            'is_available' => ['sometimes', 'boolean'],
            'published_at' => ['sometimes', 'nullable', 'date'],
            'video_url' => ['sometimes', 'nullable', 'url', 'max:255'],
            'virtual_tour_url' => ['sometimes', 'nullable', 'url', 'max:255'],
            'nearby_places' => ['sometimes', 'nullable', 'array'],
            'nearby_places.*.name' => ['required', 'string', 'max:100'],
            'nearby_places.*.distance' => ['required', 'string', 'max:50'],
            'nearby_places.*.type' => ['required', 'string', 'max:50'],
        ];
    }
}
