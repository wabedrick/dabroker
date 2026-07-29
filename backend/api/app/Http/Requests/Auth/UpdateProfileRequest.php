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
        $user = $this->user();
        $userId = $user->id;

        $rules = [
            'name' => ['sometimes', 'string', 'max:255'],
            'phone' => ['sometimes', 'string', 'max:20', 'unique:users,phone,' . $userId],
            'country_code' => ['sometimes', 'string', 'max:10'],
            'bio' => ['nullable', 'string', 'max:1000'],
        ];

        if ($user->hasRole('super_admin')) {
            $rules['email'] = ['sometimes', 'email', 'max:255', 'unique:users,email,' . $userId];
        }

        return $rules;
    }
}
