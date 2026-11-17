import 'dart:convert';

import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/main.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:app_produk/ubah_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
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
        title: Text('Halaman Produk'),
        backgroundColor: Color.fromRGBO(255, 250, 237, 202),
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _listData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailProduk(
                                  mapData: {
                                    'idProduk': _listData[index]['id_produk'],
                                    'namaProduk':
                                        _listData[index]['nama_produk'],
                                    'hargaProduk':
                                        _listData[index]['harga_produk'],
                                  },
                                ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(_listData[index]['nama_produk']),
                        subtitle: Text(_listData[index]['harga_produk']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => UbahProduk(
                                          mapData: {
                                            'idProduk':
                                                _listData[index]['id_produk'],
                                            'namaProduk':
                                                _listData[index]['nama_produk'],
                                            'hargaProduk':
                                                _listData[index]['harga_produk'],
                                          },
                                        ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text('Yakin hapus data ini?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _hapusData(
                                              _listData[index]['id_produk'],
                                            ).then((value) {
                                              navigatorKey.currentState!
                                                  .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              HalamanProduk(),
                                                    ),
                                                    (route) => false,
                                                  );
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(255, 250, 237, 202),
                                          ),
                                          child: Text('Hapus'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(255, 250, 237, 202),
                                          ),
                                          child: Text('Batal'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(255, 250, 237, 202),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahProduk()),
          );
        },
        child: Text('+', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
