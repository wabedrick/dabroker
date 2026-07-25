<?php
$req1 = json_decode(file_get_contents('http://192.168.42.66:8000/api/v1/properties?per_page=50'), true);
$req2 = json_decode(file_get_contents('http://192.168.42.66:8000/api/v1/properties?category=rent&per_page=50'), true);
foreach($req2['data'] as $p2) {
    foreach($req1['data'] as $p1) {
        if($p1['id'] == $p2['id'] && $p1['category'] != $p2['category']) {
            echo "Mismatch: " . $p1['id'] . " - all: " . $p1['category'] . " rent: " . $p2['category'] . PHP_EOL;
        }
    }
}
echo "Done.";
