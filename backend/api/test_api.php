<?php

// API Testing Script
$baseUrl = 'http://127.0.0.1:8000/api/v1';
$results = [];

function apiRequest($method, $url, $data = null, $headers = []) {
    $ch = curl_init();
    $defaultHeaders = ['Content-Type: application/json', 'Accept: application/json'];
    $allHeaders = array_merge($defaultHeaders, $headers);
    
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $allHeaders);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    
    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'code' => $httpCode,
        'body' => json_decode($response, true)
    ];
}

echo "=================================\n";
echo "Backend API Testing\n";
echo "=================================\n\n";

// Test 1: Public Properties API
echo "1. Testing GET /properties...\n";
$response = apiRequest('GET', "$baseUrl/properties");
$results['properties'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
echo "   Status: {$response['code']}\n";
echo "   Result: {$results['properties']}\n\n";

// Test 2: Public Lodgings API
echo "2. Testing GET /lodgings...\n";
$response = apiRequest('GET', "$baseUrl/lodgings");
$results['lodgings'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
echo "   Status: {$response['code']}\n";
echo "   Result: {$results['lodgings']}\n\n";

// Test 3: Public Professionals API
echo "3. Testing GET /professionals...\n";
$response = apiRequest('GET', "$baseUrl/professionals");
$results['professionals'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
echo "   Status: {$response['code']}\n";
echo "   Result: {$results['professionals']}\n\n";

// Test 4: Register a new user
echo "4. Testing POST /auth/register...\n";
$userData = [
    'name' => 'Test User ' . time(),
    'email' => 'testuser' . time() . '@example.com',
    'phone' => '+2567000' . rand(10000, 99999),
    'country_code' => '+256',
    'password' => 'password1234',
    'password_confirmation' => 'password1234',
    'preferred_role' => 'buyer'
];
$response = apiRequest('POST', "$baseUrl/auth/register", $userData);
$results['register'] = in_array($response['code'], [200, 201, 202]) ? '✅ PASS' : '❌ FAIL';
echo "   Status: {$response['code']}\n";
echo "   Result: {$results['register']}\n";
if (isset($response['body']['data']['user']['email'])) {
    echo "   User created: {$response['body']['data']['user']['email']}\n";
}
echo "\n";

// Test 5: Login
echo "5. Testing POST /auth/login...\n";
$loginData = [
    'identifier' => $userData['email'],
    'password' => $userData['password']
];
$response = apiRequest('POST', "$baseUrl/auth/login", $loginData);
$results['login'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
$token = $response['body']['token'] ?? null;
echo "   Status: {$response['code']}\n";
echo "   Result: {$results['login']}\n";
if ($token) {
    echo "   Token received: " . substr($token, 0, 20) . "...\n";
}
echo "\n";

if ($token) {
    // Test 6: Get profile
    echo "6. Testing GET /profile (authenticated)...\n";
    $response = apiRequest('GET', "$baseUrl/profile", null, ["Authorization: Bearer $token"]);
    $results['profile'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['profile']}\n\n";
    
    // Test 7: Apply to be a professional
    echo "7. Testing POST /professionals/apply (authenticated)...\n";
    $professionalData = [
        'license_number' => 'LIC' . time(),
        'specialties' => ['Real Estate', 'Legal'],
        'bio' => 'Test professional bio',
        'hourly_rate' => 100
    ];
    $response = apiRequest('POST', "$baseUrl/professionals/apply", $professionalData, ["Authorization: Bearer $token"]);
    $results['professional_apply'] = in_array($response['code'], [200, 201]) ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['professional_apply']}\n\n";
    
    // Test 8: Get consultations
    echo "8. Testing GET /consultations (authenticated)...\n";
    $response = apiRequest('GET', "$baseUrl/consultations", null, ["Authorization: Bearer $token"]);
    $results['consultations'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['consultations']}\n\n";
    
    // Test 9: Create a lodging (host)
    echo "9. Testing POST /host/lodgings (authenticated)...\n";
    $lodgingData = [
        'title' => 'Test Apartment',
        'type' => 'apartment',
        'price_per_night' => 100,
        'max_guests' => 4,
        'description' => 'A beautiful test apartment',
        'city' => 'Kampala',
        'country' => 'Uganda'
    ];
    $response = apiRequest('POST', "$baseUrl/host/lodgings", $lodgingData, ["Authorization: Bearer $token"]);
    $results['create_lodging'] = in_array($response['code'], [200, 201]) ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['create_lodging']}\n";
    $lodgingId = $response['body']['data']['id'] ?? null;
    if ($lodgingId) {
        echo "   Lodging created: $lodgingId\n";
    }
    echo "\n";
    
    // Test 10: Get host lodgings
    echo "10. Testing GET /host/lodgings (authenticated)...\n";
    $response = apiRequest('GET', "$baseUrl/host/lodgings", null, ["Authorization: Bearer $token"]);
    $results['host_lodgings'] = $response['code'] == 200 ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['host_lodgings']}\n\n";
    
    // Test 11: Logout
    echo "11. Testing POST /auth/logout (authenticated)...\n";
    $response = apiRequest('POST', "$baseUrl/auth/logout", null, ["Authorization: Bearer $token"]);
    $results['logout'] = in_array($response['code'], [200, 204]) ? '✅ PASS' : '❌ FAIL';
    echo "   Status: {$response['code']}\n";
    echo "   Result: {$results['logout']}\n\n";
} else {
    echo "⚠️  Skipping authenticated tests (no token)\n\n";
}

// Summary
echo "=================================\n";
echo "Test Summary\n";
echo "=================================\n";
$passed = count(array_filter($results, fn($r) => $r === '✅ PASS'));
$total = count($results);
foreach ($results as $test => $result) {
    echo str_pad($test, 20) . ": $result\n";
}
echo "\nTotal: $passed/$total passed\n";
echo "=================================\n";
