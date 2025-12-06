<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->can('admin.manage_users') ?? false;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'name' => ['sometimes', 'string', 'max:255'],
            'email' => ['sometimes', 'email', 'max:255', 'unique:users,email,' . $this->user->id],
            'phone' => ['sometimes', 'string', 'max:20'],
            'country_code' => ['sometimes', 'string', 'max:5'],
            'bio' => ['sometimes', 'nullable', 'string', 'max:1000'],
            'status' => ['sometimes', 'string', 'in:active,banned,suspended,pending'],
            'preferred_role' => ['sometimes', 'nullable', 'string', 'max:50'],
            'roles' => ['sometimes', 'array'],
            'roles.*' => ['string', 'exists:roles,name'],
            'metadata' => ['sometimes', 'array'],
        ];
    }
}
