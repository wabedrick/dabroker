<?php
$data = array(
    'identifier' => 'dotest2@example.com'
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
$result = file_get_contents('https://daborker-jacei.ondigitalocean.app/api/v1/auth/password/forgot', false, $context);
echo "Forgot Password: " . $result . "\n";
