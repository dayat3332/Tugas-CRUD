# CodeNecromancer

Tugas besar (TUBES) mata kuliah **Pemrograman Mobile 1 (Politeknik Negeri Indramayu)**.  
**CodeNecromancer** adalah aplikasi Flutter berbentuk marketplace blueprint kode, dengan peran pembeli (*buyer*) dan penjual (*seller*), serta backend PHP + MySQL yang dijalankan memakai Docker.

**Branch:** `tubas`

---

## Fitur

- **Splash screen, login, dan registrasi** (pemilihan peran, indikator kekuatan password)
- **Pembeli (Buyer):** beranda, pencarian dan filter, pustaka (*library*), pesanan, wishlist, dan permintaan kode (*request code*)
- **Penjual (Seller):** halaman jual (*sell*) untuk mengelola blueprint
- **Proses CRUD blueprint:** tambah, lihat, ubah, dan hapus (*Create, Read, Update, Delete*) melalui API PHP
- **Profil pengguna**
- **Navigasi bawah (*bottom navigation bar*) dan tema aplikasi terpusat**

---

## Teknologi

| Bagian | Teknologi |
|---|---|
| **Frontend** | Flutter (Dart) |
| **Backend / API** | PHP, format JSON |
| **Database** | MySQL (`database/init.sql`) |
| **Lingkungan** | Docker (`Dockerfile`, `docker-compose.yml`) |

---

## Struktur Proyek

```text
.
├── lib/
│   ├── config/api_config.dart           # konfigurasi alamat API
│   ├── constants/app_assets.dart        # daftar aset gambar
│   ├── models/blueprint_model.dart
│   ├── screens/                         # login, register, home, library, orders,
│   │   ├── buyer/                       # wishlist, request code, profile, dll.
│   │   └── seller/
│   ├── services/blueprint_service.dart
│   ├── navigation/                      # bottom nav bar
│   ├── theme/app_theme.dart
│   ├── widgets/                         # komponen UI yang dipakai ulang
│   └── main.dart
├── htdocs/api_blueprint/                # API PHP: create, read, edit, update, delete, koneksi
├── database/init.sql                    # struktur dan data awal database
├── image/                               # aset gambar dan ikon
├── test/                                # pengujian (assets_test, crud_test, widget_test)
├── Dockerfile
└── docker-compose.yml
```

---

## Cara Menjalankan

### 1. Jalankan Docker
```bash
docker compose up -d
```
> **Catatan Database:** `database/init.sql` berisi struktur dan data awal; impor lewat phpMyAdmin (`http://localhost:8080`) jika belum otomatis dimuat.

### 2. Cek Alamat IP Komputer
```bash
hostname -I
```
Atur alamat API di `lib/config/api_config.dart` sesuai IP komputer (atau atur melalui tombol konfigurasi IP di dalam aplikasi).

### 3. Jalankan Aplikasi
```bash
flutter pub get
flutter run
```

### 4. Jalankan Pengujian (Opsional)
```bash
flutter test
```

> **Perhatian:** Pastikan perangkat dan komputer berada pada jaringan yang sama, dan firewall mengizinkan port web server.

---

## Pembuat

- **Nama:** Diding Hidayat
- **NIM:** 2505032
- **GitHub:** [@dayat3332](https://github.com/dayat3332)
