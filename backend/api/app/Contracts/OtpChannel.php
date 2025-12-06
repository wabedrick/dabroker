<?php

namespace App\Contracts;

interface OtpChannel
{
    public function send(string $identifier, string $code, string $purpose): void;
}
