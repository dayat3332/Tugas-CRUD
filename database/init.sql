-- Database: db_code_necromancer
CREATE DATABASE IF NOT EXISTS `db_code_necromancer`;
USE `db_code_necromancer`;

-- Table structure for tb_blueprints
CREATE TABLE IF NOT EXISTS `tb_blueprints` (
  `id_blueprint` INT(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `author` VARCHAR(255) NOT NULL,
  `price` VARCHAR(100) NOT NULL,
  `stack_label` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `is_verified` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_blueprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed initial blueprints data
INSERT INTO `tb_blueprints` (`id_blueprint`, `title`, `author`, `price`, `stack_label`, `description`, `is_verified`) VALUES
(1, 'Sistem ERP UMKM (Next.js)', 'NecroArch Studio', 'Rp 2.500.000', 'Next.js', 'Enterprise Resource Planning terpadu untuk UMKM manufaktur dan inventaris barang berbasis SSR modern dengan performa tinggi.', 1),
(2, 'Payment Gateway Core (Laravel)', 'Lazarus Vault Lab', 'Rp 3.850.000', 'Laravel', 'Modul pembayaran multi-vendor terintegrasi Midtrans, Xendit, dan webhook otomatis dengan arsitektur secure transaction.', 1),
(3, 'Mobile POS & Kasir Online (Flutter)', 'CyberNecro Dev', 'Rp 1.750.000', 'Flutter', 'Aplikasi kasir pintar multi-platform responsif offline-first dengan sinkronisasi cloud real-time dan struk thermal bluetooth.', 1),
(4, 'AI Prompt & Sentiment Engine (FastAPI)', 'Aether Logic', 'Rp 4.200.000', 'FastAPI', 'High-throughput async REST API untuk analisis sentimen teks, klasifikasi data cerdas, dan caching pipeline model LLM.', 1);
