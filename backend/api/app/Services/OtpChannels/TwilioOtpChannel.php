<?php

namespace App\Services\OtpChannels;

use App\Contracts\OtpChannel;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use RuntimeException;

class TwilioOtpChannel implements OtpChannel
{
    public function __construct(private readonly array $config = []) {}

    public function send(string $identifier, string $code, string $purpose): void
    {
        $sid = $this->config['sid'] ?? null;
        $token = $this->config['token'] ?? null;
        $from = $this->config['from'] ?? null;
        $messagingServiceSid = $this->config['messaging_service_sid'] ?? null;

        if (! $sid || ! $token || (! $from && ! $messagingServiceSid)) {
            throw new RuntimeException('Twilio OTP channel misconfigured.');
        }

        $endpoint = sprintf('https://api.twilio.com/2010-04-01/Accounts/%s/Messages.json', $sid);

        $payload = [
            'To' => $identifier,
            'Body' => sprintf('Your Broker verification code is %s. It expires in %d minutes.', $code, (int) ceil(config('otp.ttl', 300) / 60)),
        ];

        if ($messagingServiceSid) {
            $payload['MessagingServiceSid'] = $messagingServiceSid;
        } else {
            $payload['From'] = $from;
        }

        Http::withBasicAuth($sid, $token)
            ->asForm()
            ->post($endpoint, $payload)
            ->throw();

        Log::info('OTP sent via Twilio', [
            'to' => Str::mask($identifier, '*', 3),
            'purpose' => $purpose,
        ]);
    }
}
