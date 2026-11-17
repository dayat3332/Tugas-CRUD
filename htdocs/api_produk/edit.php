<?php
require_once 'koneksi.php';

$idProduk = isset($_POST['id_produk']) ? (int)$_POST['id_produk'] : 0;
$namaProduk = isset($_POST['nama_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['nama_produk'])) : '';
$hargaProduk = isset($_POST['harga_produk']) ? (int)$_POST['harga_produk'] : 0;
$gambarProduk = isset($_POST['gambar_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['gambar_produk'])) : '';
$deskripsiProduk = isset($_POST['deskripsi_produk']) ? mysqli_real_escape_string($koneksi, trim($_POST['deskripsi_produk'])) : '';

if ($idProduk <= 0) {
    echo json_encode([
        "success" => false,
        "message" => "ID produk tidak valid"
    ]);
    exit();
}

if (empty($namaProduk)) {
    echo json_encode([
        "success" => false,
        "message" => "Nama produk tidak boleh kosong"
    ]);
    exit();
}

$query = "UPDATE tb_produk SET 
            nama_produk='$namaProduk', 
            harga_produk='$hargaProduk', 
            gambar_produk='$gambarProduk', 
            deskripsi_produk='$deskripsiProduk' 
          WHERE id_produk='$idProduk'";

$data = mysqli_query($koneksi, $query);

if ($data) {
    echo json_encode([
        "success" => true,
        "message" => "Produk berhasil diubah"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Produk gagal diubah: " . mysqli_error($koneksi)
    ]);
}
