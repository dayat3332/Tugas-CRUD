# CodeNecromancer - Flutter Marketplace & CRUD dengan Docker

Aplikasi Marketplace Blueprint Source Code dengan implementasi lengkap metode **CRUD (Create, Read, Update, Delete)** yang terhubung langsung ke database **MySQL** melalui container **Docker (Apache + PHP API + MySQL + phpMyAdmin)**.

---

## 🚀 Arsitektur Docker & Backend

Sistem backend menggunakan Docker Compose dengan 3 service:
1. **`web`** (Apache + PHP 8.2 + ekstensi `mysqli`):
   - Port: `http://localhost:80`
   - Volume: `./htdocs` di-mount ke `/var/www/html`
   - Direktori API: `htdocs/api_blueprint/`
2. **`db`** (MySQL 8.0):
   - Port: `3306`
   - Database: `db_code_necromancer`
   - Tabel: `tb_blueprints`
   - Inisialisasi otomatis: `database/init.sql`
   - User: `necro_user` / `necro_password` (Root: `rootpassword`)
3. **`phpmyadmin`** (phpMyAdmin Web GUI):
   - Port: `http://localhost:8080`
   - Server: `db`
   - Password Root: `rootpassword`

---

## 🛠️ Menjalankan Docker

### 1. Menjalankan Container (Background)
```bash
docker compose up -d
```

### 2. Memeriksa Status Container
```bash
docker compose ps
```

### 3. Menghentikan Container
```bash
docker compose stop
```

### 4. Membuka phpMyAdmin di Browser
Buka browser dan akses:
```
http://localhost:8080
```
- **Server:** `db`
- **Username:** `root`
- **Password:** `rootpassword`

---

## 📡 Daftar Endpoint REST API

| Metode | Endpoint | Deskripsi |
|---|---|---|
| **GET** | `/api_blueprint/read.php` | Mengambil seluruh daftar blueprint dari MySQL (mendukung query `search` & `stack`) |
| **POST** | `/api_blueprint/create.php` | Menambahkan blueprint baru ke MySQL |
| **POST** | `/api_blueprint/update.php` | Memperbarui data blueprint berdasarkan `id_blueprint` |
| **POST** | `/api_blueprint/delete.php` | Menghapus blueprint berdasarkan `id_blueprint` |

---

## 📱 Fitur CRUD pada Aplikasi Flutter

1. **Create (Tambah)**:
   - Tombol **"Tambah"** pada status bar dashboard atau floating action button di Seller Studio (`/sell`).
   - Formulir validasi: Judul, Author/Publisher, Harga Valuasi, Ekosistem/Stack (Choice Chips), Deskripsi, dan AST Verification switch.
2. **Read (Tampil Data)**:
   - Data otomatis diambil dari Docker MySQL via `BlueprintService`.
   - Mendukung pencarian teks (*live search*), filter kategori (*CategoryChips*), dan *Pull-to-Refresh* (*swipe down*).
   - Tapping kartu menampilkan halaman detail `IPDetailScreen`.
   - Dilengkapi *graceful fallback* jika Docker backend sedang offline.
3. **Update (Ubah)**:
   - Tombol **"Edit"** di setiap kartu blueprint di Seller Studio (`/sell`) atau ikon edit di `IPDetailScreen`.
   - Mengisi data lama ke dalam formulir dan memperbarui data di MySQL secara instan.
4. **Delete (Hapus)**:
   - Tombol **"Hapus"** dengan dialog konfirmasi keamanan di Seller Studio (`/sell`) atau ikon hapus di `IPDetailScreen`.

---

## 🌐 Konfigurasi IP untuk Perangkat Android

- **Android Emulator:** otomatis menggunakan `10.0.2.2`
- **Linux Desktop / Web:** otomatis menggunakan `127.0.0.1` (atau `localhost`)
- **HP Fisik Android via Wi-Fi:**
  Klik tombol **"IP Host"** pada banner status Docker di dashboard aplikasi untuk mengubah IP menjadi IP Wi-Fi laptop (misal: `192.168.0.150`).
