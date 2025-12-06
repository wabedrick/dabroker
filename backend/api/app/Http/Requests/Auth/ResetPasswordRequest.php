<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class ResetPasswordRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'identifier' => ['required', 'string', 'max:255'],
            'otp' => ['required', 'digits_between:4,6'],
            'password' => ['required', 'string', 'min:10', 'confirmed'],
        ];
    }
}
