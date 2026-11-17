import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_necromancer/main.dart';
import 'package:code_necromancer/screens/splash_screen.dart';
import 'package:code_necromancer/screens/login_screen.dart';
import 'package:code_necromancer/screens/register_screen.dart';
import 'package:code_necromancer/screens/buyer/home_screen.dart';
import 'package:code_necromancer/screens/buyer/wishlist_screen.dart';
import 'package:code_necromancer/screens/buyer/library_screen.dart';
import 'package:code_necromancer/screens/buyer/orders_screen.dart';
import 'package:code_necromancer/screens/profile_screen.dart';
import 'package:code_necromancer/screens/buyer/filter_search_screen.dart';
import 'package:code_necromancer/screens/buyer/request_code_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo on white background and transitions to Login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 950);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('CodeNecromancer'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('LoginScreen renders all elements from screenshot 1',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 950);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    expect(find.text('Email Pengembang'), findsOneWidget);
    expect(find.text('Verified ID'), findsNothing);
    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.text('Ingat saya'), findsOneWidget);
    expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
    expect(find.text('Masuk Sekarang'), findsOneWidget);
    expect(find.text('Lanjutkan dengan GitHub'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  testWidgets('RegisterScreen renders all elements from screenshot 2',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Buat Akun Developer'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Wajib'), findsNothing);
    expect(find.text('Email Kerja / Developer'), findsOneWidget);
    expect(find.text('Untuk verifikasi lisensi'), findsNothing);
    expect(find.text('Kata Sandi Baru'), findsOneWidget);
    expect(find.text('Entropy 98%'), findsNothing);
    expect(find.text('Kekuatan Sandi: '), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    // Test dynamic password strength
    final passwordInput = find.byType(TextFormField).last;
    await tester.enterText(passwordInput, 'abc');
    await tester.pumpAndSettle();
    expect(find.text('Rendah (50%)'), findsOneWidget);

    await tester.enterText(passwordInput, 'NecroVault_2025!');
    await tester.pumpAndSettle();
    expect(find.text('Kuat (100%)'), findsOneWidget);

    expect(find.text('Peran Utama Anda'), findsOneWidget);
    expect(find.text('Buyer / Developer'), findsOneWidget);
    expect(find.text('Seller / Publisher'), findsOneWidget);
    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(find.text('Masuk di sini'), findsOneWidget);

    // Toggle role
    await tester.ensureVisible(find.text('Daftar Akun Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seller / Publisher'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Publikasikan blueprint Anda'), findsOneWidget);
  });

  testWidgets('HomeScreen renders all elements from screenshot 3',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Revive & Ship'), findsOneWidget);
    expect(find.text('Production Code'), findsOneWidget);
    expect(find.text('Featured Blueprints'), findsOneWidget);
    expect(find.text('All Stacks'), findsOneWidget);
    expect(find.text('Tidak Ada Blueprint yang Cocok'), findsOneWidget);
    expect(find.text('Reset Filter & Pencarian'), findsOneWidget);
    expect(find.text('Ajukan Request Kode'), findsOneWidget);

    // Bottom Navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap tag "Flutter"
    await tester.ensureVisible(find.text('Flutter'));
    await tester.tap(find.text('Flutter'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Full navigation flow works between all screens',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const CodeNecromancerApp(initialRoute: '/login'));
    await tester.pumpAndSettle();

    // From Login, navigate to Register
    await tester.ensureVisible(find.text('Daftar Sekarang'));
    await tester.tap(find.text('Daftar Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Akun Developer'), findsOneWidget);

    // From Register, navigate back to Login
    await tester.ensureVisible(find.text('Masuk di sini'));
    await tester.tap(find.text('Masuk di sini'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat Datang Kembali'), findsOneWidget);

    // From Login, tap Masuk Sekarang to go to Home
    final loginButton = find.widgetWithText(ElevatedButton, 'Masuk Sekarang');
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Revive & Ship'), findsOneWidget);

    // From Home, tap Wishlist tab
    await tester.tap(find.text('Wishlist'));
    await tester.pumpAndSettle();
    expect(find.text('Wishlist Proyek'), findsOneWidget);

    // From Wishlist, tap "Lihat Pustaka Kode" button
    await tester.ensureVisible(find.text('Lihat Pustaka Kode'));
    await tester.tap(find.text('Lihat Pustaka Kode'));
    await tester.pumpAndSettle();
    expect(find.text('Pustaka Repositori'), findsOneWidget);

    // From Library, tap "Cek Wishlist Proyek Tersimpan" button
    await tester.ensureVisible(find.text('Cek Wishlist Proyek Tersimpan'));
    await tester.tap(find.text('Cek Wishlist Proyek Tersimpan'));
    await tester.pumpAndSettle();
    expect(find.text('Wishlist Proyek'), findsOneWidget);

    // From Wishlist, tap Library tab
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Pustaka Repositori'), findsOneWidget);

    // From Library, tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Pengguna Baru'), findsOneWidget);

    // From Profile, tap Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Revive & Ship'), findsOneWidget);
  });

  testWidgets('WishlistScreen renders all elements from screenshot 1',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: WishlistScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wishlist Proyek'), findsOneWidget);
    expect(find.text('0 Proyek'), findsOneWidget);
    expect(find.text('PERKIRAAN ANGGARAN SPRINT'), findsOneWidget);
    expect(find.text('Kosong'), findsOneWidget);
    expect(find.text('Estimasi Total Budget'), findsOneWidget);
    expect(find.text('Rp 0'), findsNWidgets(2));
    expect(find.text('0 Blueprint terpilih'), findsOneWidget);
    expect(find.text('Potongan / Hemat'), findsOneWidget);
    expect(find.text('Diskon bundle pasif'), findsOneWidget);
    expect(find.textContaining('IDR-SYC : READY'), findsOneWidget);

    // Empty state card
    expect(find.text('Wishlist Anda Masih Kosong'), findsOneWidget);
    expect(find.text('Jelajahi Marketplace'), findsOneWidget);
    expect(find.text('Lihat Pustaka Kode'), findsOneWidget);

    // Info section
    expect(find.text('Kenapa Menggunakan Wishlist?'), findsOneWidget);
    expect(find.text('Pantau Penurunan Harga & Flash Sale'), findsOneWidget);
    expect(find.text('Bundle Checkout Lebih Hemat'), findsOneWidget);
    expect(find.text('Rencana Arsitektur Sprint'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Tekan ikon bookmark'),
      ),
      findsWidgets,
    );
  });

  testWidgets('LibraryScreen renders all elements from screenshot 2',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: LibraryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pustaka Repositori'), findsOneWidget);
    expect(find.text('Repositori'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Dimiliki'), findsOneWidget);
    expect(find.text('Aset Kode'), findsOneWidget);
    expect(find.text('Rp 0'), findsOneWidget);
    expect(find.text('Valuasi'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Sync Belum Aktif'), findsOneWidget);

    // Empty state card
    expect(find.textContaining('Brankas Grimoire Anda Masih'), findsOneWidget);
    expect(find.text('Jelajahi Blueprint di Marketplace'), findsOneWidget);
    expect(find.text('Cek Wishlist Proyek Tersimpan'), findsOneWidget);

    // Guide section
    expect(find.text('Bagaimana Cara Kerja Grimoire?'), findsOneWidget);
    expect(find.text('Beli Blueprint'), findsOneWidget);
    expect(find.text('Akses Otomatis'), findsOneWidget);
    expect(find.text('Update Seumur Hidup'), findsOneWidget);
    expect(
        find.textContaining(
            'Transaksi bergaransi & source code diaudit otomatis oleh CodeNecromancer.'),
        findsOneWidget);
  });

  testWidgets('ProfileScreen renders all elements from screenshot',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1300);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pengguna Baru'), findsOneWidget);
    expect(find.text('Akun Baru'), findsOneWidget);
    expect(find.text('@developer_baru'), findsOneWidget);
    expect(find.text('Profil Belum Lengkap'), findsOneWidget);
    expect(find.text('Kelengkapan Profil'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Lengkapi Profil'), findsOneWidget);
    expect(find.text('Bagikan'), findsOneWidget);

    // Stats Grid
    expect(find.text('Dibeli'), findsOneWidget);
    expect(find.text('Repos'), findsOneWidget);
    expect(find.text('Diterbitkan'), findsOneWidget);
    expect(find.text('Modul'), findsOneWidget);
    expect(find.text('Skor Kepercayaan'), findsOneWidget);
    expect(find.text('Unranked'), findsOneWidget);
    expect(find.text('Senioritas'), findsOneWidget);
    expect(find.text('2025'), findsOneWidget);
    expect(find.text('Baru Gabung'), findsOneWidget);

    // Panduan Memulai
    expect(find.text('PANDUAN MEMULAI'), findsOneWidget);
    expect(find.text('Bangun Reputasi Developer'), findsOneWidget);
    expect(find.text('Hubungkan Akun GitHub'), findsOneWidget);
    expect(find.text('Atur Dompet Payout'), findsOneWidget);
    expect(find.text('Bio & Keahlian Teknis'), findsOneWidget);

    // Kredensial Pengembang
    expect(find.text('Kredensial Pengembang'), findsOneWidget);
    expect(find.text('v2.4.0 Engine'), findsOneWidget);
    expect(find.text('Status GitHub'), findsOneWidget);
    expect(find.text('Belum Terhubung'), findsOneWidget);
    expect(find.text('Tautkan GitHub'), findsOneWidget);
    expect(find.text('Dompet Pendapatan'), findsOneWidget);
    expect(find.text('Nonaktif'), findsOneWidget);
    expect(find.text('Konfigurasi Rekening Payout'), findsOneWidget);

    // Keamanan & Preferensi
    expect(find.text('Keamanan & Preferensi'), findsOneWidget);
    expect(find.text('Pengaturan Keamanan AST'), findsOneWidget);
    expect(find.text('Tema Tampilan'), findsOneWidget);
    expect(find.text('Lazarus Precision Light'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);
    expect(find.text('Bahasa Antarmuka'), findsOneWidget);
    expect(find.text('Bahasa Indonesia (ID)'), findsOneWidget);

    // Bottom action buttons
    expect(find.text('Dokumentasi & Dukungan Teknis'), findsOneWidget);
    expect(find.text('Keluar dari Akun (Sign Out)'), findsOneWidget);
  });

  testWidgets('FilterSearchScreen renders all elements from screenshot',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1300);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: FilterSearchScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Filter & Pencarian'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('KATA KUNCI PENCARIAN'), findsOneWidget);
    expect(find.textContaining('Rust WebAssembly'), findsOneWidget);
    expect(find.textContaining('Filter Aktif'), findsOneWidget);
    expect(find.text('Reset Semua'), findsOneWidget);

    // Ecosystem
    expect(find.text('Ekosistem & Bahasa'), findsOneWidget);
    expect(find.text('Multi-pilih'), findsOneWidget);
    expect(find.text('Rust'), findsOneWidget);
    expect(find.text('PHP / Laravel'), findsOneWidget);

    // AST Audit
    expect(find.text('Kualitas & Audit AST'), findsOneWidget);
    expect(find.text('Strict Standard'), findsOneWidget);
    expect(find.text('AST Verified Only'), findsOneWidget);
    expect(find.text('100% Health Score'), findsOneWidget);
    expect(find.text('Dokumentasi & Test Suite'), findsOneWidget);
    expect(find.text('Siap Komersial'), findsOneWidget);
    expect(find.text('Unrestricted'), findsOneWidget);

    // Price
    expect(find.textContaining('Rentang Harga'), findsOneWidget);
    expect(find.text('Semua Harga'), findsOneWidget);
    expect(find.text('Rp 200rb - 500rb'), findsOneWidget);
    expect(find.text('Harga Terendah'), findsOneWidget);
    expect(find.text('Harga Maksimal'), findsOneWidget);

    // Sort
    expect(find.text('Urutkan Hasil'), findsOneWidget);
    expect(find.text('Paling Populer & Terlaris'), findsOneWidget);
    expect(find.text('Terbaru Diunggah'), findsOneWidget);

    // Bottom actions
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Terapkan (12 Hasil)'), findsOneWidget);
  });

  testWidgets('RequestCodeScreen renders all elements from screenshot',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: RequestCodeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ajukan Request Kode'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);

    // Empty search banner
    expect(find.text('HASIL PENCARIAN KOSONG'), findsOneWidget);
    expect(find.text('0 Hasil'), findsOneWidget);
    expect(find.text('Reset Filter & Pencarian'), findsOneWidget);
    expect(find.text('Katalog'), findsOneWidget);

    // Target ecosystem
    expect(find.text('Target Ekosistem & Bahasa'), findsOneWidget);
    expect(find.text('Laravel'), findsOneWidget);
    expect(find.text('Framework / Runtime Spesifik'), findsOneWidget);

    // Module specs
    expect(find.text('Spesifikasi Modul'), findsOneWidget);
    expect(find.text('Judul Kebutuhan Kode'), findsOneWidget);
    expect(find.text('Markdown Didukung'), findsOneWidget);

    // Budget bounty
    expect(find.text('Budget Bounty'), findsOneWidget);
    expect(find.text('Rp 250.000'), findsOneWidget);
    expect(find.text('Rp 500.000'), findsOneWidget);
    expect(find.text('Rp 1.000.000'), findsOneWidget);

    // Timeline
    expect(find.text('Target Waktu Penyelesaian'), findsOneWidget);
    expect(find.text('1 Minggu'), findsOneWidget);

    // Broadcast
    expect(find.text('Broadcast ke 150+ Necro Seller'), findsOneWidget);

    // Guarantee
    expect(find.text('NecroEngine AST Guarantee'), findsOneWidget);

    // Action buttons
    expect(find.text('Kirim Permintaan & Buka Bounty'), findsOneWidget);
    expect(find.text('Reset Formulir & Kembali ke Beranda'), findsOneWidget);
  });

  testWidgets('HomeScreen Button 2 navigates to RequestCodeScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final button2 = find.text('Ajukan Request Kode');
    expect(button2, findsOneWidget);

    await tester.ensureVisible(button2);
    await tester.tap(button2);
    await tester.pumpAndSettle();

    // Verifies RequestCodeScreen opened
    expect(find.text('Ajukan Request Kode'), findsOneWidget);
    expect(find.text('HASIL PENCARIAN KOSONG'), findsOneWidget);
  });
}
