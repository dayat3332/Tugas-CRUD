import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/product_model.dart';
import 'api_service.dart';

/// Response standar dari operasi backend
class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(dynamic json) {
    if (json is String) {
      try {
        json = jsonDecode(json);
      } catch (_) {}
    }

    if (json is Map<String, dynamic>) {
      return ApiResponse(
        success: json['success'] == true || json['success'] == 1 || json['success'] == 'true',
        message: json['message']?.toString() ?? 'Operasi selesai',
        data: json,
      );
    }

    return const ApiResponse(
      success: false,
      message: 'Format respon tidak valid dari server',
    );
  }
}

/// Service PBO untuk mengelola seluruh logika API CRUD Produk.
/// Mengisolasi pemanggilan endpoint dan parsing data dari UI / State Management.
class ProductService {
  final ApiService _apiService;

  ProductService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Mengambil daftar semua produk dari read.php
  Future<List<Product>> getProducts() async {
    final response = await _apiService.get(ApiConfig.readEndpoint);

    dynamic responseData = response.data;
    if (responseData is String) {
      try {
        responseData = jsonDecode(responseData);
      } catch (e) {
        debugPrint('Gagal decode response read.php: $e');
      }
    }

    if (responseData is List) {
      return responseData
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// Menambahkan produk baru via create.php
  Future<ApiResponse> createProduct(Product product) async {
    final response = await _apiService.postFormData(
      ApiConfig.createEndpoint,
      data: product.toFormData(),
    );
    return ApiResponse.fromJson(response.data);
  }

  /// Mengubah data produk via edit.php
  Future<ApiResponse> updateProduct(Product product) async {
    if (product.idProduk == null) {
      return const ApiResponse(
        success: false,
        message: 'ID Produk wajib disertakan saat update',
      );
    }
    final response = await _apiService.postFormData(
      ApiConfig.editEndpoint,
      data: product.toFormData(),
    );
    return ApiResponse.fromJson(response.data);
  }

  /// Menghapus produk via delete.php
  Future<ApiResponse> deleteProduct(int idProduk) async {
    final response = await _apiService.postFormData(
      ApiConfig.deleteEndpoint,
      data: {'id_produk': idProduk.toString()},
    );
    return ApiResponse.fromJson(response.data);
  }
}
