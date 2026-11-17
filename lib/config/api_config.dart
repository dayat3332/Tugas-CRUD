import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class konfigurasi API dengan pendekatan PBO (Pemrograman Berorientasi Objek).
/// Semua konfigurasi IP address dan endpoint dienkapsulasi dalam class ini,
/// sehingga perubahan IP address hanya perlu dilakukan pada class ini,
/// tanpa harus mengubah kode di setiap file/screen.
class ApiConfig {
  // Key SharedPreferences untuk menyimpan IP kustom jika diubah oleh pengguna
  static const String _prefKeyIp = 'custom_api_ip';

  // IP default berdasarkan platform (Android Emulator pakai 10.0.2.2, selain itu 127.0.0.1 / localhost)
  static String get _defaultHost {
    if (kIsWeb) return '127.0.0.1';
    try {
      if (Platform.isAndroid) return '10.0.2.2';
    } catch (_) {}
    return '127.0.0.1';
  }

  static const String _defaultPath = 'api_produk';
  static const int _defaultPort = 80;

  static String _currentHost = _defaultHost;
  static int _currentPort = _defaultPort;

  /// Inisialisasi konfigurasi dari SharedPreferences (jika pernah disimpan)
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIp = prefs.getString(_prefKeyIp);
      if (savedIp != null && savedIp.trim().isNotEmpty) {
        _currentHost = savedIp.trim();
      }
    } catch (e) {
      debugPrint('Gagal memuat konfigurasi IP tersimpan: $e');
    }
  }

  /// Getter Host / IP saat ini
  static String get currentHost => _currentHost;

  /// Getter Port saat ini
  static int get currentPort => _currentPort;

  /// Base URL API lengkap
  static String get baseUrl {
    if (_currentPort == 80) {
      return 'http://$_currentHost/$_defaultPath';
    }
    return 'http://$_currentHost:$_currentPort/$_defaultPath';
  }

  /// Endpoint Read Produk
  static String get readEndpoint => '$baseUrl/read.php';

  /// Endpoint Create Produk
  static String get createEndpoint => '$baseUrl/create.php';

  /// Endpoint Edit/Update Produk
  static String get editEndpoint => '$baseUrl/edit.php';

  /// Endpoint Delete Produk
  static String get deleteEndpoint => '$baseUrl/delete.php';

  /// Method PBO untuk memperbarui Host/IP secara dinamis dan menyimpannya
  static Future<void> setHost(String newHost, {int port = 80}) async {
    _currentHost = newHost.trim();
    _currentPort = port;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyIp, _currentHost);
    } catch (e) {
      debugPrint('Gagal menyimpan IP baru ke SharedPreferences: $e');
    }
  }

  /// Reset ke IP default
  static Future<void> resetToDefault() async {
    _currentHost = _defaultHost;
    _currentPort = _defaultPort;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKeyIp);
    } catch (e) {
      debugPrint('Gagal mereset IP ke default: $e');
    }
  }
}
