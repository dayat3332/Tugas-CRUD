<?php
require_once 'koneksi.php';

$search = isset($_GET['search']) ? mysqli_real_escape_string($koneksi, trim($_GET['search'])) : '';
$stack  = isset($_GET['stack']) ? mysqli_real_escape_string($koneksi, trim($_GET['stack'])) : '';
$id     = isset($_GET['id']) ? (int)$_GET['id'] : 0;

$whereClauses = [];

if ($id > 0) {
    $whereClauses[] = "id_blueprint = '$id'";
}

if (!empty($search)) {
    $whereClauses[] = "(title LIKE '%$search%' OR author LIKE '%$search%' OR description LIKE '%$search%' OR stack_label LIKE '%$search%')";
}

if (!empty($stack) && strtolower($stack) !== 'semua' && strtolower($stack) !== 'all') {
    $whereClauses[] = "LOWER(stack_label) = LOWER('$stack')";
}

$sql = "SELECT * FROM tb_blueprints";
if (count($whereClauses) > 0) {
    $sql .= " WHERE " . implode(" AND ", $whereClauses);
}
$sql .= " ORDER BY id_blueprint DESC";

$query = mysqli_query($koneksi, $sql);
$data = [];

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        // Cast types appropriately
        $row['id_blueprint'] = (int)$row['id_blueprint'];
        $row['is_verified'] = (int)$row['is_verified'] === 1;
        $data[] = $row;
    }
}

echo json_encode([
    "success" => true,
    "total" => count($data),
    "data" => $data
]);
