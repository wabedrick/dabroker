<?php

namespace App\Http\Requests\Notification;

use Illuminate\Foundation\Http\FormRequest;

class UpdateNotificationPreferenceRequest extends FormRequest
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
            'inquiries' => ['sometimes', 'array'],
            'inquiries.email' => ['sometimes', 'boolean'],
            'inquiries.push' => ['sometimes', 'boolean'],
            'favorites' => ['sometimes', 'array'],
            'favorites.email' => ['sometimes', 'boolean'],
            'favorites.push' => ['sometimes', 'boolean'],
        ];
    }
}
