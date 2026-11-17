import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/currency_formatter.dart';

/// Halaman Form Tambah & Ubah Produk.
/// Memenuhi persyaratan:
/// 1. Tampilan loading saat proses create/update berlangsung hingga berhasil.
/// 2. Format currency preview (IDR) saat memasukkan harga.
/// 3. Pengolahan data gambar produk dengan live preview (opsional).
class ProductFormScreen extends StatefulWidget {
  final Product? product; // Null jika mode Tambah, berisi data jika mode Ubah

  const ProductFormScreen({super.key, this.product});

  bool get isEditMode => product != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late final TextEditingController _gambarController;
  late final TextEditingController _deskripsiController;

  String _formattedPreviewPrice = 'Rp 0';
  String _imagePreviewUrl = '';

  // Template gambar cepat untuk kemudahan demo / pengujian
  final List<Map<String, String>> _sampleImages = [
    {
      'name': 'Laptop',
      'url':
          'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500',
    },
    {
      'name': 'Keyboard',
      'url':
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500',
    },
    {
      'name': 'Mouse',
      'url':
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500',
    },
    {
      'name': 'Headset',
      'url':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    },
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _namaController = TextEditingController(text: p?.namaProduk ?? '');
    _hargaController =
        TextEditingController(text: p != null ? p.hargaProduk.toString() : '');
    _gambarController = TextEditingController(text: p?.gambarProduk ?? '');
    _deskripsiController =
        TextEditingController(text: p?.deskripsiProduk ?? '');

    if (p != null) {
      _formattedPreviewPrice = CurrencyFormatter.formatToRupiah(p.hargaProduk);
      _imagePreviewUrl = p.gambarProduk ?? '';
    }

    _hargaController.addListener(() {
      final parsed = CurrencyFormatter.parseRupiah(_hargaController.text);
      setState(() {
        _formattedPreviewPrice = CurrencyFormatter.formatToRupiah(parsed);
      });
    });

    _gambarController.addListener(() {
      setState(() {
        _imagePreviewUrl = _gambarController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _gambarController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<ProductProvider>();
    final parsedHarga = CurrencyFormatter.parseRupiah(_hargaController.text);

    final productData = Product(
      idProduk: widget.product?.idProduk,
      namaProduk: _namaController.text.trim(),
      hargaProduk: parsedHarga,
      gambarProduk: _gambarController.text.trim().isNotEmpty
          ? _gambarController.text.trim()
          : null,
      deskripsiProduk: _deskripsiController.text.trim().isNotEmpty
          ? _deskripsiController.text.trim()
          : null,
    );

    final response = widget.isEditMode
        ? await provider.updateProduct(productData)
        : await provider.addProduct(productData);

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
      Navigator.pop(context, true);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ProductProvider>();
    final isLoading = provider.isActionLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Ubah Data Produk' : 'Tambah Produk Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview Gambar Produk
              Center(
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _imagePreviewUrl.isNotEmpty
                        ? Image.network(
                            _imagePreviewUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image_outlined,
                                      size: 48, color: Colors.grey.shade500),
                                  const SizedBox(height: 8),
                                  Text(
                                    'URL Gambar tidak valid / tidak dapat dimuat',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 48, color: Colors.grey.shade500),
                              const SizedBox(height: 8),
                              Text(
                                'Preview Gambar Produk',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Chip Pilihan Gambar Sampel Cepat
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Contoh: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ..._sampleImages.map((sample) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ActionChip(
                          label: Text(sample['name']!,
                              style: const TextStyle(fontSize: 12)),
                          onPressed: isLoading
                              ? null
                              : () {
                                  _gambarController.text = sample['url']!;
                                },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Nama Produk
              TextFormField(
                controller: _namaController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Nama Produk *',
                  hintText: 'Contoh: Laptop Asus ROG',
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input Harga Produk dengan Live IDR Preview
              TextFormField(
                controller: _hargaController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Produk (IDR) *',
                  hintText: 'Contoh: 1500000',
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'Preview Format: $_formattedPreviewPrice',
                  helperStyle: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Harga produk wajib diisi';
                  }
                  final number = CurrencyFormatter.parseRupiah(val);
                  if (number <= 0) {
                    return 'Harga produk harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input URL Gambar Produk
              TextFormField(
                controller: _gambarController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'URL Gambar Produk (Opsional)',
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: const Icon(Icons.image_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _gambarController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: isLoading
                              ? null
                              : () => _gambarController.clear(),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Input Deskripsi Produk
              TextFormField(
                controller: _deskripsiController,
                enabled: !isLoading,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk (Opsional)',
                  hintText: 'Masukkan penjelasan detail atau spesifikasi produk...',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Simpan dengan status Loading indikator
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Menyimpan data...'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.isEditMode ? Icons.check : Icons.save),
                          const SizedBox(width: 8),
                          Text(
                            widget.isEditMode
                                ? 'Perbarui Produk'
                                : 'Simpan Produk',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
