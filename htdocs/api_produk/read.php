<?php
require_once 'koneksi.php';

$query = mysqli_query($koneksi, "SELECT * FROM tb_produk ORDER BY id_produk DESC");
$data = [];

if ($query) {
    $data = mysqli_fetch_all($query, MYSQLI_ASSOC);
}

echo json_encode($data);
