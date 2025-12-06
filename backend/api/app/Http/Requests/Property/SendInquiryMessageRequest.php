<?php

namespace App\Http\Requests\Property;

use Illuminate\Foundation\Http\FormRequest;

class SendInquiryMessageRequest extends FormRequest
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
            'message' => ['required', 'string', 'min:1', 'max:1000'],
            'metadata' => ['nullable', 'array'],
        ];
    }
}
