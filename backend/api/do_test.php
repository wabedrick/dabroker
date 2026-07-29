<?php
$data = array(
    'name' => 'Test User',
    'email' => 'dotest2@example.com',
    'phone' => '+1999999992',
    'country_code' => '+1',
    'password' => 'password1234',
    'password_confirmation' => 'password1234',
    'preferred_role' => 'buyer'
);

$options = array(
    'http' => array(
        'header'  => "Content-type: application/json\r\n" . "Accept: application/json\r\n",
        'method'  => 'POST',
        'content' => json_encode($data),
        'ignore_errors' => true
    )
);

$context  = stream_context_create($options);
$result = file_get_contents('https://daborker-jacei.ondigitalocean.app/api/v1/auth/register', false, $context);
echo "Register: " . $result . "\n";

$loginData = array(
    'identifier' => 'dotest2@example.com',
    'password' => 'password1234'
);

$loginOptions = array(
    'http' => array(
        'header'  => "Content-type: application/json\r\n" . "Accept: application/json\r\n",
        'method'  => 'POST',
        'content' => json_encode($loginData),
        'ignore_errors' => true
    )
);

$loginContext  = stream_context_create($loginOptions);
$loginResult = file_get_contents('https://daborker-jacei.ondigitalocean.app/api/v1/auth/login', false, $loginContext);
echo "Login: " . $loginResult . "\n";
