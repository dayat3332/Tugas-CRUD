<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$host = getenv('DB_HOST') ?: (getenv('MYSQL_HOST') ?: 'localhost');
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASS') !== false ? getenv('DB_PASS') : '';
$db   = getenv('DB_NAME') ?: 'db_produk';

// Coba koneksi ke host default, fallback ke 127.0.0.1 atau db (docker)
$koneksi = @new mysqli($host, $user, $pass, $db);
if ($koneksi->connect_error) {
    $koneksi = @new mysqli('127.0.0.1', $user, $pass, $db);
    if ($koneksi->connect_error) {
        $koneksi = @new mysqli('db', 'root', 'rootpassword', $db);
    }
}

if ($koneksi->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . $koneksi->connect_error
    ]);
    exit();
}
