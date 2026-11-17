<?php
require_once 'koneksi.php';

$namaProduk = isset($_POST['nama_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['nama_produk'])) : '';
$hargaProduk = isset($_POST['harga_produk']) ? (int)$_POST['harga_produk'] : 0;
$gambarProduk = isset($_POST['gambar_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['gambar_produk'])) : '';
$deskripsiProduk = isset($_POST['deskripsi_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['deskripsi_produk'])) : '';

if (empty($namaProduk)) {
    echo json_encode([
        "success" => false,
        "message" => "Nama produk tidak boleh kosong"
    ]);
    exit();
}

$query = "INSERT INTO tb_produk (nama_produk, harga_produk, gambar_produk, deskripsi_produk) 
          VALUES ('$namaProduk', '$hargaProduk', '$gambarProduk', '$deskripsiProduk')";

$data = mysqli_query($koneksi, $query);

if ($data) {
    echo json_encode([
        "success" => true,
        "message" => "Produk berhasil ditambahkan",
        "id_produk" => mysqli_insert_id($koneksi)
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Produk gagal ditambahkan: " . mysqli_error($koneksi)
    ]);
}
