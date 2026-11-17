import 'dart:io';
import 'package:flutter/foundation.dart';

/// Class konfigurasi API Docker untuk CodeNecromancer.
/// Menerapkan prinsip Enkapsulasi (PBO).
/// Otomatis mendeteksi platform (Android Emulator -> 10.0.2.2, Desktop/Web -> 127.0.0.1).
class ApiConfig {
  ApiConfig._();

  // Host default sesuai platform
  static String get _defaultHost {
    if (kIsWeb) return '127.0.0.1';
    try {
      if (Platform.isAndroid) return '10.0.2.2';
    } catch (_) {}
    return '127.0.0.1';
  }

  static String _host = _defaultHost;
  static int _port = 80;
  static const String _basePath = 'api_blueprint';

  /// Getter Host
  static String get host => _host;

  /// Ubah Host (berguna saat pengujian dengan HP fisik via Wi-Fi, misalnya '192.168.0.150')
  static void setHost(String newHost) {
    _host = newHost.trim();
  }

  /// Getter Port
  static int get port => _port;

  /// Ubah Port jika port Apache diubah
  static void setPort(int newPort) {
    _port = newPort;
  }

  /// Reset host ke default sesuai platform
  static void resetHost() {
    _host = _defaultHost;
    _port = 80;
  }

  /// Base URL API
  static String get baseUrl {
    if (_port == 80) {
      return 'http://$_host/$_basePath';
    }
    return 'http://$_host:$_port/$_basePath';
  }

  // Endpoint CRUD
  static Uri get readEndpoint => Uri.parse('$baseUrl/read.php');
  static Uri get createEndpoint => Uri.parse('$baseUrl/create.php');
  static Uri get updateEndpoint => Uri.parse('$baseUrl/update.php');
  static Uri get deleteEndpoint => Uri.parse('$baseUrl/delete.php');

  /// URL filter baca data
  static Uri filterEndpoint({String? search, String? stack, int? id}) {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (stack != null && stack.isNotEmpty && stack.toLowerCase() != 'semua') {
      params['stack'] = stack;
    }
    if (id != null && id > 0) params['id'] = id.toString();

    final uri = Uri.parse('$baseUrl/read.php');
    return uri.replace(queryParameters: params.isNotEmpty ? params : null);
  }
}
