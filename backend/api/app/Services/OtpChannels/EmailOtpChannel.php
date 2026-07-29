<?php

namespace App\Services\OtpChannels;

use App\Contracts\OtpChannel;
use App\Mail\OtpMail;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class EmailOtpChannel implements OtpChannel
{
    public function __construct(private readonly array $config = []) {}

    public function send(string $identifier, string $code, string $purpose): void
    {
        Mail::to($identifier)->send(new OtpMail($code, $purpose));

        Log::info('OTP sent via Email', [
            'to' => Str::mask($identifier, '*', 3),
            'purpose' => $purpose,
        ]);
    }
}
