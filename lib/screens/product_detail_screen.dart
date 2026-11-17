import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'product_form_screen.dart';

/// Halaman Detail Produk dengan kaidah UX modern.
/// Menampilkan banner hero, format harga IDR, metadata produk,
/// serta tombol aksi Edit dan Delete dengan dialog konfirmasi dan SnackBar.
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _currentProduct;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  Future<void> _confirmDelete() async {
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
          'Apakah Anda yakin ingin menghapus produk "${_currentProduct.namaProduk}"? Tindakan ini tidak dapat dibatalkan.',
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
    final response = await provider.deleteProduct(_currentProduct.idProduk!);

    if (!mounted) return;

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(response.message)),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(response.message)),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(product: _currentProduct),
      ),
    );

    if (result == true && mounted) {
      // Perbarui tampilan dengan data terbaru dari provider
      final provider = context.read<ProductProvider>();
      final updated = provider.allProducts.firstWhere(
        (p) => p.idProduk == _currentProduct.idProduk,
        orElse: () => _currentProduct,
      );
      setState(() {
        _currentProduct = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ProductProvider>();
    final isDeleting = provider.isActionLoading;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Banner Gambar dengan SliverAppBar
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _currentProduct.namaProduk,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _currentProduct.gambarProduk != null &&
                          _currentProduct.gambarProduk!.isNotEmpty
                      ? Image.network(
                          _currentProduct.gambarProduk!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  size: 64, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: theme.colorScheme.primaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                  // Gradient shadow agar judul selalu terbaca jelas
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Konten Detail Produk
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge ID dan Harga Format Rupiah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ID: #${_currentProduct.idProduk ?? '-'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentProduct.formattedPrice,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nama Lengkap Produk
                  Text(
                    _currentProduct.namaProduk,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Deskripsi Produk
                  Text(
                    'Deskripsi Produk',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentProduct.deskripsiProduk != null &&
                            _currentProduct.deskripsiProduk!.isNotEmpty
                        ? _currentProduct.deskripsiProduk!
                        : 'Tidak ada deskripsi untuk produk ini.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Informasi Tambahan / Kaidah UX
                  Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.verified_outlined, color: Colors.green),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Produk ini tersinkronisasi langsung dengan basis data MySQL melalui API backend.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // Padding untuk bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar Aksi (Edit & Delete)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isDeleting ? null : _navigateToEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Ubah Data'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isDeleting ? null : _confirmDelete,
                  icon: isDeleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.delete_outline),
                  label: Text(isDeleting ? 'Menghapus...' : 'Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
