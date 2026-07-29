<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .container { background-color: #f9f9f9; border-radius: 8px; padding: 30px; text-align: center; }
        .logo { font-size: 24px; font-weight: bold; color: #2c3e50; margin-bottom: 20px; }
        .otp-code { font-size: 36px; font-weight: bold; letter-spacing: 5px; color: #3498db; margin: 30px 0; padding: 15px; background: #fff; border-radius: 8px; border: 1px solid #e1e1e1; display: inline-block; }
        .footer { margin-top: 30px; font-size: 12px; color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Broker App</div>
        <h2>Verification Code</h2>
        <p>You requested a verification code to {{ $purpose === 'registration' ? 'verify your new account' : 'reset your password' }}.</p>
        <p>Please enter the following 6-digit code in the app:</p>
        
        <div class="otp-code">{{ $code }}</div>
        
        <p>This code will expire in {{ ceil(config('otp.ttl', 300) / 60) }} minutes.</p>
        <p>If you did not request this code, please ignore this email.</p>
        
        <div class="footer">
            &copy; {{ date('Y') }} Broker App. All rights reserved.
        </div>
    </div>
</body>
</html>
