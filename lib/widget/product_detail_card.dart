import 'package:flutter/material.dart';

/// Widget Card detail produk yang di-slicing dari DetailProduk
class ProductDetailCard extends StatelessWidget {
  final String idProduk;
  final String namaProduk;
  final String hargaProduk;

  const ProductDetailCard({
    super.key,
    required this.idProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('ID Produk'),
              subtitle: Text(idProduk),
            ),
            ListTile(
              title: const Text('Nama Produk'),
              subtitle: Text(namaProduk),
            ),
            ListTile(
              title: const Text('Harga Produk'),
              subtitle: Text(hargaProduk),
            ),
          ],
        ),
      ),
    );
  }
}
