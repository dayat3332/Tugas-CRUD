<?php
require_once 'koneksi.php';

// Mendukung payload baik x-www-form-urlencoded maupun raw JSON
$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    $input = $_POST;
}

$idBlueprint = isset($input['id_blueprint']) ? (int)$input['id_blueprint'] : (isset($input['id']) ? (int)$input['id'] : 0);
$title       = isset($input['title']) ? mysqli_real_escape_string($koneksi, trim($input['title'])) : '';
$author      = isset($input['author']) ? mysqli_real_escape_string($koneksi, trim($input['author'])) : '';
$price       = isset($input['price']) ? mysqli_real_escape_string($koneksi, trim($input['price'])) : '';
$stackLabel  = isset($input['stack_label']) ? mysqli_real_escape_string($koneksi, trim($input['stack_label'])) : '';
$description = isset($input['description']) ? mysqli_real_escape_string($koneksi, trim($input['description'])) : '';
$isVerified  = isset($input['is_verified']) && ($input['is_verified'] === 0 || $input['is_verified'] === false || $input['is_verified'] === '0') ? 0 : 1;

if ($idBlueprint <= 0) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "ID blueprint tidak valid"
    ]);
    exit();
}

if (empty($title)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Judul blueprint tidak boleh kosong"
    ]);
    exit();
}

$sql = "UPDATE tb_blueprints SET 
            title = '$title',
            author = '$author',
            price = '$price',
            stack_label = '$stackLabel',
            description = '$description',
            is_verified = '$isVerified'
        WHERE id_blueprint = '$idBlueprint'";

$result = mysqli_query($koneksi, $sql);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Blueprint berhasil diperbarui"
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Gagal memperbarui blueprint: " . mysqli_error($koneksi)
    ]);
}
