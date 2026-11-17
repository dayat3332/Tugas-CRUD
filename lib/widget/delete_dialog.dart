import 'package:flutter/material.dart';

/// Widget dialog konfirmasi hapus data yang di-slicing dari HalamanProduk
class DeleteDialog extends StatelessWidget {
  final VoidCallback onHapus;
  final VoidCallback? onBatal;

  const DeleteDialog({
    super.key,
    required this.onHapus,
    this.onBatal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Yakin hapus data ini?'),
      actions: [
        ElevatedButton(
          onPressed: onHapus,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 250, 237, 202),
          ),
          child: const Text('Hapus'),
        ),
        ElevatedButton(
          onPressed: onBatal ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 250, 237, 202),
          ),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}
