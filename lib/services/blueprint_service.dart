import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/blueprint_model.dart';

class BlueprintService {
  // Timeout request 5 detik
  static const Duration _timeoutDuration = Duration(seconds: 5);

  /// Default fallback blueprints jika database docker belum terhubung
  static List<BlueprintModel> get defaultBlueprints => const [
        BlueprintModel(
          id: 1,
          title: 'Sistem ERP UMKM (Next.js)',
          author: 'NecroArch Studio',
          price: 'Rp 2.500.000',
          stackLabel: 'Next.js',
          description:
              'Enterprise Resource Planning terpadu untuk UMKM manufaktur dan inventaris barang berbasis SSR modern dengan performa tinggi.',
          isVerified: true,
        ),
        BlueprintModel(
          id: 2,
          title: 'Payment Gateway Core (Laravel)',
          author: 'Lazarus Vault Lab',
          price: 'Rp 3.850.000',
          stackLabel: 'Laravel',
          description:
              'Modul pembayaran multi-vendor terintegrasi Midtrans, Xendit, dan webhook otomatis dengan arsitektur secure transaction.',
          isVerified: true,
        ),
      ];

  /// READ: Mengambil seluruh blueprint dari MySQL melalui Docker backend
  Future<List<BlueprintModel>> getBlueprints({
    String? search,
    String? stack,
  }) async {
    try {
      final uri = ApiConfig.filterEndpoint(search: search, stack: stack);
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final list = decoded['data'] as List;
          return list
              .map((item) =>
                  BlueprintModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (decoded is List) {
          return decoded
              .map((item) =>
                  BlueprintModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      debugPrint('BlueprintService: GET gagal status ${response.statusCode}');
      return defaultBlueprints;
    } catch (e) {
      debugPrint('BlueprintService: Error saat fetch blueprints: $e');
      // Kembalikan fallback default jika Docker offline/error
      return defaultBlueprints;
    }
  }

  /// CREATE: Menambahkan blueprint baru ke database
  Future<bool> createBlueprint(BlueprintModel blueprint) async {
    try {
      final response = await http
          .post(
            ApiConfig.createEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(blueprint.toJson()),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('BlueprintService: Error createBlueprint: $e');
      return false;
    }
  }

  /// UPDATE: Memperbarui blueprint yang sudah ada di database
  Future<bool> updateBlueprint(BlueprintModel blueprint) async {
    try {
      final response = await http
          .post(
            ApiConfig.updateEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(blueprint.toJson()),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('BlueprintService: Error updateBlueprint: $e');
      return false;
    }
  }

  /// DELETE: Menghapus blueprint berdasarkan ID dari database
  Future<bool> deleteBlueprint(int id) async {
    try {
      final response = await http
          .post(
            ApiConfig.deleteEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id_blueprint': id}),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('BlueprintService: Error deleteBlueprint: $e');
      return false;
    }
  }

  /// Memeriksa status konektivitas ke Docker backend
  Future<bool> isBackendConnected() async {
    try {
      final uri = ApiConfig.readEndpoint;
      final response = await http.get(uri).timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
