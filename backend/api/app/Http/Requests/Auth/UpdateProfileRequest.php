<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $userId = $this->user()->id;

        return [
            'name' => ['sometimes', 'string', 'max:255'],
            'email' => ['sometimes', 'email', 'max:255', 'unique:users,email,' . $userId],
            'phone' => ['sometimes', 'string', 'max:20', 'unique:users,phone,' . $userId],
            'country_code' => ['sometimes', 'string', 'max:10'],
            'bio' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
