import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service jaringan dasar menggunakan package Dio (Latihan 2 Bonus).
/// Mendukung interceptor, timeout, dan penanganan error yang konsisten.
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor untuk logging pada mode debug
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }
  }

  Dio get client => _dio;

  /// Melakukan GET request ke URL tertentu
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(url, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Melakukan POST request dengan format Form-Data (standar PHP $_POST)
  Future<Response<T>> postFormData<T>(
    String url, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final formData = FormData.fromMap(data);
      return await _dio.post<T>(url, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Menangani pesan error Dio menjadi kalimat ramah pengguna
  Exception _handleError(DioException e) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Koneksi ke server timeout (waktu habis). Periksa IP address.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Gagal mengirim data ke server dalam batas waktu.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server terlalu lama merespons. Periksa koneksi backend.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        message = 'Server mengembalikan error (Status code: $statusCode).';
        break;
      case DioExceptionType.cancel:
        message = 'Permintaan dibatalkan.';
        break;
      case DioExceptionType.connectionError:
        message =
            'Tidak dapat terhubung ke server. Pastikan IP backend aktif dan benar.';
        break;
      default:
        message = 'Terjadi kesalahan jaringan: ${e.message}';
        break;
    }
    return Exception(message);
  }
}
