import 'package:flutter_test/flutter_test.dart';
import 'package:crud_flutter/models/product_model.dart';
import 'package:crud_flutter/config/api_config.dart';
import 'package:crud_flutter/providers/product_provider.dart';
import 'package:crud_flutter/utils/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PBO & Currency Formatter Tests (Latihan 1)', () {
    test('CurrencyFormatter memformat angka ke Rupiah dengan benar', () {
      expect(CurrencyFormatter.formatToRupiah(0), 'Rp 0');
      expect(CurrencyFormatter.formatToRupiah(15000), 'Rp 15.000');
      expect(CurrencyFormatter.formatToRupiah(24500000), 'Rp 24.500.000');
    });

    test('CurrencyFormatter membersihkan string harga menjadi integer', () {
      expect(CurrencyFormatter.parseRupiah('Rp 15.000'), 15000);
      expect(CurrencyFormatter.parseRupiah('24.500.000'), 24500000);
      expect(CurrencyFormatter.parseRupiah('abc'), 0);
    });

    test('Product Model PBO mengonversi JSON dan FormData dengan tepat', () {
      final json = {
        'id_produk': '10',
        'nama_produk': 'Mouse Wireless',
        'harga_produk': '250000',
        'gambar_produk': 'https://example.com/mouse.png',
        'deskripsi_produk': 'Mouse hemat daya',
      };

      final product = Product.fromJson(json);

      expect(product.idProduk, 10);
      expect(product.namaProduk, 'Mouse Wireless');
      expect(product.hargaProduk, 250000);
      expect(product.formattedPrice, 'Rp 250.000');
      expect(product.gambarProduk, 'https://example.com/mouse.png');

      final formData = product.toFormData();
      expect(formData['id_produk'], '10');
      expect(formData['nama_produk'], 'Mouse Wireless');
      expect(formData['harga_produk'], '250000');
    });

    test('ApiConfig (PBO) menghasilkan endpoint URL terpusat dengan benar', () async {
      SharedPreferences.setMockInitialValues({});
      await ApiConfig.setHost('192.168.1.100', port: 80);

      expect(ApiConfig.currentHost, '192.168.1.100');
      expect(ApiConfig.baseUrl, 'http://192.168.1.100/api_produk');
      expect(ApiConfig.readEndpoint, 'http://192.168.1.100/api_produk/read.php');
      expect(ApiConfig.createEndpoint, 'http://192.168.1.100/api_produk/create.php');
      expect(ApiConfig.editEndpoint, 'http://192.168.1.100/api_produk/edit.php');
      expect(ApiConfig.deleteEndpoint, 'http://192.168.1.100/api_produk/delete.php');
    });
  });

  group('Global State Management Tests (Latihan 2 Provider)', () {
    test('ProductProvider search query filter produk secara reaktif', () {
      final provider = ProductProvider();
      expect(provider.isLoading, false);
      expect(provider.isActionLoading, false);
      expect(provider.searchQuery, '');

      provider.setSearchQuery('laptop');
      expect(provider.searchQuery, 'laptop');
    });
  });
}
