-- Database: db_produk
CREATE DATABASE IF NOT EXISTS `db_produk`;
USE `db_produk`;

-- Table structure for tb_produk
CREATE TABLE IF NOT EXISTS `tb_produk` (
  `id_produk` int(11) NOT NULL AUTO_INCREMENT,
  `nama_produk` varchar(255) NOT NULL,
  `harga_produk` varchar(255) NOT NULL,
  `gambar_produk` text DEFAULT NULL,
  `deskripsi_produk` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_produk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping initial sample data for tb_produk (1 data saja)
INSERT INTO `tb_produk` (`id_produk`, `nama_produk`, `harga_produk`) VALUES
(1, 'Sepatu Sneakers', '250000');
