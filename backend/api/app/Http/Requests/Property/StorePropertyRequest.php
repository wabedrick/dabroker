<?php

namespace App\Http\Requests\Property;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StorePropertyRequest extends FormRequest
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
        $propertyTypes = ['land', 'house'];

        return [
            'title' => ['required', 'string', 'max:150'],
            'type' => ['required', Rule::in($propertyTypes)],
            'category' => ['nullable', 'string', 'max:120'],
            'price' => ['nullable', 'numeric', 'min:0'],
            'currency' => ['required', 'string', 'size:3'],
            'size' => ['nullable', 'numeric', 'min:0'],
            'size_unit' => ['nullable', 'string', 'max:20'],
            'house_age' => ['nullable', 'integer', 'min:0', 'max:200'],
            'address' => ['nullable', 'string', 'max:255'],
            'city' => ['required', 'string', 'max:120'],
            'state' => ['nullable', 'string', 'max:120'],
            'country' => ['required', 'string', 'max:120'],
            'postal_code' => ['nullable', 'string', 'max:20'],
            'latitude' => ['nullable', 'numeric', 'between:-90,90'],
            'longitude' => ['nullable', 'numeric', 'between:-180,180'],
            'amenities' => ['nullable', 'array'],
            'amenities.*' => ['string', 'max:50'],
            'metadata' => ['nullable', 'array'],
            'description' => ['nullable', 'string'],
            'available_from' => ['nullable', 'date'],
            'published_at' => ['nullable', 'date'],
        ];
    }
}
