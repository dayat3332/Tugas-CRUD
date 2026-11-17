import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

/// Global State Management menggunakan Provider (Latihan 2 Bonus).
/// Mengelola state data produk, status loading create/update/delete, serta penanganan error.
class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  ProductProvider({ProductService? productService})
      : _productService = productService ?? ProductService();

  // Getters
  List<Product> get products {
    if (_searchQuery.trim().isEmpty) {
      return _products;
    }
    return _products.where((p) {
      final query = _searchQuery.toLowerCase();
      final nameMatches = p.namaProduk.toLowerCase().contains(query);
      final descMatches =
          p.deskripsiProduk?.toLowerCase().contains(query) ?? false;
      return nameMatches || descMatches;
    }).toList();
  }

  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;
  int get totalProducts => _products.length;
  String get searchQuery => _searchQuery;

  /// Mengatur query pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Membersihkan pesan error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Mengambil daftar semua produk dari backend
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambahkan produk baru
  Future<ApiResponse> addProduct(Product product) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final result = await _productService.createProduct(product);
      if (result.success) {
        // Refresh daftar produk secara otomatis
        await fetchProducts();
      }
      return result;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Mengubah/update produk yang sudah ada
  Future<ApiResponse> updateProduct(Product product) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final result = await _productService.updateProduct(product);
      if (result.success) {
        // Refresh daftar produk
        await fetchProducts();
      }
      return result;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Menghapus produk berdasarkan ID
  Future<ApiResponse> deleteProduct(int idProduk) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final result = await _productService.deleteProduct(idProduk);
      if (result.success) {
        // Hapus dari state lokal dan refresh data
        _products.removeWhere((p) => p.idProduk == idProduk);
        await fetchProducts();
      }
      return result;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
