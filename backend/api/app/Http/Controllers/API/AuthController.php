<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ForgotPasswordRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Requests\Auth\ResetPasswordRequest;
use App\Http\Requests\Auth\ResendOtpRequest;
use App\Http\Requests\Auth\VerifyOtpRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\OtpService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function __construct(private readonly OtpService $otpService) {}

    public function register(RegisterRequest $request): JsonResponse
    {
        $requiresOtp = $this->otpEnabled();

        $user = DB::transaction(function () use ($request, $requiresOtp) {
            $data = $request->validated();

            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'phone' => $data['phone'],
                'country_code' => $data['country_code'],
                'preferred_role' => $data['preferred_role'] ?? 'buyer',
                'password' => $data['password'],
                'status' => $requiresOtp ? 'pending' : 'active',
                'bio' => $data['bio'] ?? null,
                'metadata' => $data['metadata'] ?? null,
            ]);

            $role = $data['preferred_role'] ?? 'buyer';
            $user->assignRole($role);

            return $user;
        });

        if ($requiresOtp) {
            $this->otpService->send($user->phone ?? $user->email, 'registration');
        } else {
            $this->activateUserWithoutOtp($user);
        }

        return response()->json([
            'message' => $requiresOtp
                ? 'Registration successful. Verify the OTP to activate your account.'
                : 'Registration successful.',
            'data' => new UserResource($user),
        ], 201);
    }

    public function resendOtp(ResendOtpRequest $request): JsonResponse
    {
        $data = $request->validated();

        $user = $this->findUserByIdentifier($data['identifier'], true);

        if (! $this->otpEnabled()) {
            $this->activateUserWithoutOtp($user);

            return response()->json([
                'message' => 'OTP verification is currently disabled.',
                'data' => new UserResource($user->fresh()),
            ]);
        }

        $this->otpService->send($data['identifier'], $data['purpose']);

        return response()->json([
            'message' => 'OTP resent successfully.',
        ]);
    }

    public function verifyOtp(VerifyOtpRequest $request): JsonResponse
    {
        $data = $request->validated();

        if (! $this->otpEnabled()) {
            $user = $this->findUserByIdentifier($data['identifier']);
            $this->activateUserWithoutOtp($user);

            return response()->json([
                'message' => 'OTP verified successfully.',
                'data' => new UserResource($user->fresh()),
            ]);
        }

        if (! $this->otpService->verify($data['identifier'], $data['purpose'], $data['otp'])) {
            throw ValidationException::withMessages([
                'otp' => __('Invalid or expired OTP code.'),
            ]);
        }

        $user = $this->findUserByIdentifier($data['identifier']);

        if ($data['purpose'] === 'registration') {
            $user->update([
                'status' => 'active',
                'phone_verified_at' => filter_var($data['identifier'], FILTER_VALIDATE_EMAIL) ? $user->phone_verified_at : now(),
                'email_verified_at' => filter_var($data['identifier'], FILTER_VALIDATE_EMAIL) ? now() : $user->email_verified_at,
            ]);
        }

        return response()->json([
            'message' => 'OTP verified successfully.',
            'data' => new UserResource($user->fresh()),
        ]);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $credentials = $request->validated();
        $identifier = $credentials['identifier'];

        $user = User::query()
            ->where('email', $identifier)
            ->orWhere('phone', $identifier)
            ->first();

        if (! $user || ! Hash::check($credentials['password'], $user->password)) {
            throw ValidationException::withMessages([
                'identifier' => __('The provided credentials are incorrect.'),
            ]);
        }

        if (! $this->otpEnabled() && $user->status === 'pending') {
            $this->activateUserWithoutOtp($user);
        }

        $token = $user->createToken($credentials['device_name'] ?? 'mobile')->plainTextToken;

        $user->forceFill([
            'last_login_at' => now(),
        ])->save();

        return response()->json([
            'message' => 'Login successful.',
            'token' => $token,
            'token_type' => 'Bearer',
            'data' => new UserResource($user),
        ]);
    }

    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        $identifier = $request->validated()['identifier'];

        User::query()
            ->where('email', $identifier)
            ->orWhere('phone', $identifier)
            ->firstOrFail();

        $this->otpService->send($identifier, 'password_reset');

        return response()->json([
            'message' => 'OTP sent to the provided identifier.',
        ]);
    }

    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        $data = $request->validated();

        if (! $this->otpService->verify($data['identifier'], 'password_reset', $data['otp'])) {
            throw ValidationException::withMessages([
                'otp' => __('Invalid or expired OTP code.'),
            ]);
        }

        $user = User::query()
            ->where('email', $data['identifier'])
            ->orWhere('phone', $data['identifier'])
            ->firstOrFail();

        $user->forceFill([
            'password' => $data['password'],
            'status' => $user->status === 'pending' ? 'active' : $user->status,
        ])->save();

        $user->tokens()->delete();

        return response()->json([
            'message' => 'Password reset successful.',
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()?->currentAccessToken()?->delete();

        return response()->json([
            'message' => 'Logged out successfully.',
        ]);
    }

    public function me(Request $request): UserResource
    {
        return new UserResource($request->user());
    }

    private function otpEnabled(): bool
    {
        return (bool) config('otp.enabled', true);
    }

    private function activateUserWithoutOtp(User $user): void
    {
        $attributes = ['status' => 'active'];

        if ($user->email && ! $user->email_verified_at) {
            $attributes['email_verified_at'] = now();
        }

        if ($user->phone && ! $user->phone_verified_at) {
            $attributes['phone_verified_at'] = now();
        }

        $user->forceFill($attributes)->save();
    }

    private function findUserByIdentifier(string $identifier, bool $failWithValidationError = false): User
    {
        $user = User::query()
            ->where('email', $identifier)
            ->orWhere('phone', $identifier)
            ->first();

        if (! $user) {
            if ($failWithValidationError) {
                throw ValidationException::withMessages([
                    'identifier' => __('No user matches the provided identifier.'),
                ]);
            }

            throw (new ModelNotFoundException())->setModel(User::class);
        }

        return $user;
    }
}
