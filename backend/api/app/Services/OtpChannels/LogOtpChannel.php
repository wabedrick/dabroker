<?php

namespace App\Services\OtpChannels;

use App\Contracts\OtpChannel;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class LogOtpChannel implements OtpChannel
{
    public function send(string $identifier, string $code, string $purpose): void
    {
        Log::info('OTP code dispatched', [
            'identifier' => Str::mask($identifier, '*', 3),
            'purpose' => $purpose,
            'code' => app()->environment('testing') ? $code : 'hidden',
        ]);
    }
}
