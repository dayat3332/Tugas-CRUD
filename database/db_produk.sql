-- Database: db_produk
CREATE DATABASE IF NOT EXISTS `db_produk`;
USE `db_produk`;

-- Table structure for tb_produk
CREATE TABLE IF NOT EXISTS `tb_produk` (
  `id_produk` int(11) NOT NULL AUTO_INCREMENT,
  `nama_produk` varchar(255) NOT NULL,
  `harga_produk` int(11) NOT NULL,
  `gambar_produk` text DEFAULT NULL,
  `deskripsi_produk` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_produk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping initial sample data for tb_produk
INSERT INTO `tb_produk` (`id_produk`, `nama_produk`, `harga_produk`, `gambar_produk`, `deskripsi_produk`) VALUES
(1, 'Laptop Asus ROG Zephyrus', 24500000, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500', 'Laptop gaming tipis bertenaga AMD Ryzen 9 dan RTX 4070.'),
(2, 'Keyboard Mekanikal Keychron K2', 1250000, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500', 'Keyboard mekanikal wireless compact 75% dengan Gateron Red Switch.'),
(3, 'Mouse Logitech MX Master 3S', 1650000, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500', 'Mouse ergonomis terbaik untuk produktivitas kerja.'),
(4, 'Headset Sony WH-1000XM5', 4899000, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'Headphone ANC nirkabel dengan kualitas suara audiophile.'),
(5, 'Monitor Xiaomi Curved 34 Inch', 5200000, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500', 'Monitor gaming ultrawide 144Hz WQHD 1500R.');
