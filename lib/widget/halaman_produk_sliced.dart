import 'dart:convert';

import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/halaman_produk.dart';
import 'package:app_produk/main.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:app_produk/ubah_produk.dart';
import 'package:app_produk/widget/delete_dialog.dart';
import 'package:app_produk/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Versi HalamanProduk yang telah di-slicing menggunakan komponen-komponen di folder widget/
class HalamanProdukSliced extends StatefulWidget {
  const HalamanProdukSliced({super.key});

  @override
  State<HalamanProdukSliced> createState() => _HalamanProdukSlicedState();
}

class _HalamanProdukSlicedState extends State<HalamanProdukSliced> {
  List _listData = [];
  bool _loading = true;
  final logger = Logger();

  Future _getData() async {
    try {
      final respon = await http.get(
        Uri.parse('http://192.168.0.150/api_produk/read.php'),
      );
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          _listData = data;
          _loading = false;
        });
      }
    } catch (e) {
      logger.e("Kesalahan terjadi: $e");
    }
  }

  Future _hapusData(String? id) async {
    try {
      final respon = await http.post(
        Uri.parse('http://192.168.0.150/api_produk/delete.php'),
        body: {"id_produk": id!},
      );
      if (respon.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e("Kesalahan terjadi: $e");
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Produk (Sliced)'),
        backgroundColor: const Color.fromRGBO(255, 250, 237, 202),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _listData.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    namaProduk: _listData[index]['nama_produk'],
                    hargaProduk: _listData[index]['harga_produk'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailProduk(
                                mapData: {
                                  'idProduk': _listData[index]['id_produk'],
                                  'namaProduk': _listData[index]['nama_produk'],
                                  'hargaProduk':
                                      _listData[index]['harga_produk'],
                                },
                              ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => UbahProduk(
                                mapData: {
                                  'idProduk': _listData[index]['id_produk'],
                                  'namaProduk': _listData[index]['nama_produk'],
                                  'hargaProduk':
                                      _listData[index]['harga_produk'],
                                },
                              ),
                        ),
                      );
                    },
                    onDelete: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return DeleteDialog(
                            onHapus: () {
                              _hapusData(
                                _listData[index]['id_produk'],
                              ).then((value) {
                                navigatorKey.currentState!.pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HalamanProduk(),
                                  ),
                                  (route) => false,
                                );
                              });
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 250, 237, 202),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahProduk()),
          );
        },
        child: const Text('+', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
