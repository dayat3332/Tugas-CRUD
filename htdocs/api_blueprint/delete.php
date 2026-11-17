<?php
require_once 'koneksi.php';

// Mendukung payload baik x-www-form-urlencoded maupun raw JSON
$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    $input = $_POST;
}

$idBlueprint = isset($input['id_blueprint']) ? (int)$input['id_blueprint'] : (isset($input['id']) ? (int)$input['id'] : 0);

if ($idBlueprint <= 0) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "ID blueprint tidak valid"
    ]);
    exit();
}

$sql = "DELETE FROM tb_blueprints WHERE id_blueprint = '$idBlueprint'";
$result = mysqli_query($koneksi, $sql);

if ($result) {
    echo json_encode([
        "success" => true,
        "message" => "Blueprint berhasil dihapus"
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Gagal menghapus blueprint: " . mysqli_error($koneksi)
    ]);
}
