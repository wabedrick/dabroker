<?php

namespace App\Services;

use App\Contracts\OtpChannel;
use Illuminate\Support\Facades\Cache;

class OtpService
{
    private const CACHE_PREFIX = 'otp:';

    public function __construct(private readonly OtpChannel $channel) {}

    public function send(string $identifier, string $purpose): string
    {
        $code = (string) random_int(100000, 999999);
        $key = $this->cacheKey($identifier, $purpose);
        $ttl = config('otp.ttl', 300);

        $payload = [
            'code' => $code,
            'attempts' => 0,
            'expires_at' => now()->addSeconds($ttl)->timestamp,
        ];

        Cache::put($key, $payload, $ttl);

        $this->channel->send($identifier, $code, $purpose);

        return $code;
    }

    public function verify(string $identifier, string $purpose, string $code): bool
    {
        $key = $this->cacheKey($identifier, $purpose);
        $payload = Cache::get($key);

        if (! $payload) {
            return false;
        }

        $maxAttempts = config('otp.max_attempts', 5);
        $attempts = $payload['attempts'] ?? 0;

        if ($attempts >= $maxAttempts) {
            Cache::forget($key);

            return false;
        }

        $isValid = hash_equals($payload['code'], $code);

        if ($isValid) {
            Cache::forget($key);

            return true;
        }

        $payload['attempts'] = $attempts + 1;
        $remainingSeconds = max(($payload['expires_at'] ?? now()->timestamp) - now()->timestamp, 0);

        if ($remainingSeconds <= 0) {
            Cache::forget($key);

            return false;
        }

        Cache::put($key, $payload, $remainingSeconds);

        return false;
    }

    private function cacheKey(string $identifier, string $purpose): string
    {
        return sprintf('%s%s:%s', self::CACHE_PREFIX, $purpose, sha1($identifier));
    }
}
