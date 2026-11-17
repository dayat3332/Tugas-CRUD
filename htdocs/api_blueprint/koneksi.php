<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

mysqli_report(MYSQLI_REPORT_OFF);

// Ambil konfigurasi dari Environment Docker atau fallback default
$host = getenv('DB_HOST') ?: 'db';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASS') !== false ? getenv('DB_PASS') : 'rootpassword';
$db   = getenv('DB_NAME') ?: 'db_code_necromancer';

// Daftar host kandidat jika dijalankan di dalam atau di luar container Docker
$hostsToTry = [
    $host,
    'db',
    '127.0.0.1',
    'localhost'
];

$koneksi = null;
foreach ($hostsToTry as $h) {
    if (!$h) continue;
    // Coba koneksi
    $conn = @new mysqli($h, $user, $pass, $db);
    if (!$conn->connect_error) {
        $koneksi = $conn;
        break;
    }
}

// Jika koneksi gagal, kembalikan respons error JSON
if (!$koneksi || $koneksi->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . ($koneksi ? $koneksi->connect_error : "Host database tidak dapat dijangkau")
    ]);
    exit();
}
