<?php

namespace Tests\Unit\Otp;

use App\Services\OtpChannels\TwilioOtpChannel;
use Illuminate\Support\Facades\Http;
use RuntimeException;
use Tests\TestCase;

class TwilioOtpChannelTest extends TestCase
{
    public function test_sends_sms_via_twilio(): void
    {
        Http::fake();
        config(['otp.ttl' => 300]);

        $channel = new TwilioOtpChannel([
            'sid' => 'AC1234567890',
            'token' => 'secret-token',
            'from' => '+15550001111',
        ]);

        $channel->send('+15555550123', '123456', 'registration');

        Http::assertSent(function ($request) {
            return $request->url() === 'https://api.twilio.com/2010-04-01/Accounts/AC1234567890/Messages.json'
                && $request['To'] === '+15555550123'
                && $request['From'] === '+15550001111'
                && str_contains($request['Body'], '123456');
        });
    }

    public function test_throws_when_misconfigured(): void
    {
        $this->expectException(RuntimeException::class);

        $channel = new TwilioOtpChannel([
            'sid' => null,
            'token' => null,
        ]);

        $channel->send('+15555550000', '654321', 'registration');
    }
}
