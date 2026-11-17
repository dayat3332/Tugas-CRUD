<?php
require_once 'koneksi.php';

$idProduk = isset($_POST['id_produk']) ? (int)$_POST['id_produk'] : 0;

if ($idProduk <= 0) {
    echo json_encode([
        "success" => false,
        "message" => "ID produk tidak valid"
    ]);
    exit();
}

$data = mysqli_query($koneksi, "DELETE FROM tb_produk WHERE id_produk='$idProduk'");

if ($data) {
    echo json_encode([
        "success" => true,
        "message" => "Produk berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Produk gagal dihapus: " . mysqli_error($koneksi)
    ]);
}
