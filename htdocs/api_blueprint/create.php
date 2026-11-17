<?php
require_once 'koneksi.php';

// Mendukung payload baik x-www-form-urlencoded / multipart maupun raw JSON
$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    $input = $_POST;
}

$title       = isset($input['title']) ? mysqli_real_escape_string($koneksi, trim($input['title'])) : '';
$author      = isset($input['author']) ? mysqli_real_escape_string($koneksi, trim($input['author'])) : '';
$price       = isset($input['price']) ? mysqli_real_escape_string($koneksi, trim($input['price'])) : '';
$stackLabel  = isset($input['stack_label']) ? mysqli_real_escape_string($koneksi, trim($input['stack_label'])) : 'Laravel';
$description = isset($input['description']) ? mysqli_real_escape_string($koneksi, trim($input['description'])) : '';
$isVerified  = isset($input['is_verified']) && ($input['is_verified'] === 0 || $input['is_verified'] === false || $input['is_verified'] === '0') ? 0 : 1;

if (empty($title)) {
    echo json_encode([
        "success" => false,
        "message" => "Judul blueprint tidak boleh kosong"
    ]);
    exit();
}

if (empty($author)) {
    $author = 'Anon Necromancer';
}

if (empty($price)) {
    $price = 'Gratis';
}

$sql = "INSERT INTO tb_blueprints (title, author, price, stack_label, description, is_verified) 
        VALUES ('$title', '$author', '$price', '$stackLabel', '$description', '$isVerified')";

$result = mysqli_query($koneksi, $sql);

if ($result) {
    $newId = mysqli_insert_id($koneksi);
    echo json_encode([
        "success" => true,
        "message" => "Blueprint berhasil ditambahkan",
        "id_blueprint" => $newId
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Gagal menambahkan blueprint: " . mysqli_error($koneksi)
    ]);
}
