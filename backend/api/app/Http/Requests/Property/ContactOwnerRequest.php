<?php

namespace App\Http\Requests\Property;

use Illuminate\Foundation\Http\FormRequest;

class ContactOwnerRequest extends FormRequest
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
        return [
            'message' => ['required', 'string', 'min:10', 'max:1000'],
            'contact_method' => ['nullable', 'in:app,email,phone'],
            'contact_value' => ['nullable', 'string', 'max:150'],
            'metadata' => ['nullable', 'array'],
        ];
    }
}
