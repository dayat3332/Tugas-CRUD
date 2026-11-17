import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'settings_screen.dart';

/// Halaman Utama: Daftar Produk.
/// Mengimplementasikan seluruh kebutuhan Latihan 1 & Latihan 2:
/// 1. Konfigurasi IP terpusat PBO via SettingsScreen & ApiConfig.
/// 2. Format harga Currency Rupiah (IDR).
/// 3. SnackBar hasil delete (berhasil / gagal) lengkap dengan dialog konfirmasi.
/// 4. Indikator loading saat fetch data & mutasi data.
/// 5. Pengolahan gambar produk & preview thumbnail.
/// 6. Global State Management menggunakan Provider.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Muat data produk saat layar pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Dialog konfirmasi dan eksekusi penghapusan dengan SnackBar hasil
  Future<void> _handleDeleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${product.namaProduk}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final provider = context.read<ProductProvider>();
    final response = await provider.deleteProduct(product.idProduk!);

    if (!mounted) return;

    // Menampilkan SnackBar untuk proses delete (Berhasil / Gagal)
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Berhasil: ${response.message}'),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Gagal: ${response.message}'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ProductProvider>();
    final products = provider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk (CRUD)'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: provider.isLoading ? null : () => provider.fetchProducts(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan IP (PBO)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchProducts(),
        child: Column(
          children: [
            // Kolom Pencarian
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => provider.setSearchQuery(val),
              ),
            ),

            // Baris Info Host & Total Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Server: ${ApiConfig.currentHost}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Total: ${products.length} produk',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Konten Utama (Loading / Error / Empty / List)
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memuat daftar produk...'),
                        ],
                      ),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off_rounded,
                                size: 64, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Gagal Terhubung ke Backend',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => provider.fetchProducts(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SettingsScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.settings),
                                  label: const Text('Ubah IP'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 72, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Belum Ada Produk',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tekan tombol (+) di bawah untuk menambahkan produk pertama Anda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Thumbnail Gambar Produk
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.grey.shade200,
                                    child: product.gambarProduk != null &&
                                            product.gambarProduk!.isNotEmpty
                                        ? Image.network(
                                            product.gambarProduk!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Icon(
                                            Icons.shopping_bag_outlined,
                                            color: theme.colorScheme.primary,
                                            size: 32,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Informasi Nama & Harga Rupiah
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.namaProduk,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // Penyajian format harga IDR
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          product.formattedPrice,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: theme.colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                      if (product.deskripsiProduk != null &&
                                          product.deskripsiProduk!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            product.deskripsiProduk!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // Tombol Aksi Cepat (Edit & Delete)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 20),
                                      color: Colors.blue.shade700,
                                      tooltip: 'Ubah Data',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductFormScreen(
                                                product: product),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 20),
                                      color: Colors.red.shade600,
                                      tooltip: 'Hapus Produk',
                                      onPressed: () =>
                                          _handleDeleteProduct(product),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }
}
