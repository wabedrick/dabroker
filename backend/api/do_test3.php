<?php
$loginData = array(
    'identifier' => 'dotest2@example.com',
    'password' => 'wrongpassword123'
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
echo "Login Bad Password: " . $loginResult . "\n";

$headers = $http_response_header;
echo "Headers:\n" . implode("\n", $headers) . "\n";
