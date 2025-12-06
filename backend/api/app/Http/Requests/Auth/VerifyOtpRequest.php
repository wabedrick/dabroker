<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class VerifyOtpRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $rules = [
            'identifier' => ['required', 'string', 'max:255'],
            'purpose' => ['required', 'in:registration,password_reset,login'],
        ];

        if (config('otp.enabled', true)) {
            $rules['otp'] = ['required', 'digits_between:4,6'];
        }

        return $rules;
    }
}
