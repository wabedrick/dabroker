<?php

return [
    'enabled' => filter_var(env('OTP_ENABLED', true), FILTER_VALIDATE_BOOLEAN),
    'driver' => env('OTP_PROVIDER', 'log'),
    'ttl' => (int) env('OTP_TTL', 300),
    'max_attempts' => (int) env('OTP_MAX_ATTEMPTS', 5),

    'channels' => [
        'log' => [
            'class' => App\Services\OtpChannels\LogOtpChannel::class,
        ],
        'twilio' => [
            'class' => App\Services\OtpChannels\TwilioOtpChannel::class,
            'sid' => env('OTP_TWILIO_ACCOUNT_SID'),
            'token' => env('OTP_TWILIO_AUTH_TOKEN'),
            'from' => env('OTP_TWILIO_FROM'),
            'messaging_service_sid' => env('OTP_TWILIO_MESSAGING_SERVICE_SID'),
        ],
    ],
];
