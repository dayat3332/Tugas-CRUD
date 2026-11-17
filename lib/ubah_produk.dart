import 'dart:convert';

import 'package:app_produk/halaman_produk.dart';
import 'package:app_produk/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UbahProduk extends StatefulWidget {

  final Map mapData;

  const UbahProduk({super.key, required this.mapData});

  @override
  State<UbahProduk> createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final formKey = GlobalKey<FormState>();
  TextEditingController idProduk = TextEditingController();
  TextEditingController namaProduk = TextEditingController();
  TextEditingController hargaProduk = TextEditingController();
  final logger = Logger();

  Future<bool> ubah() async {
    try {
      final respon = await http.post(
        Uri.parse('http://192.168.0.150/api_produk/edit.php'),
        body: {
          'id_produk': idProduk.text,
          'nama_produk': namaProduk.text,
          'harga_produk': hargaProduk.text,
        },
      );
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.e('Terjadi kesalahan: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    idProduk.text = widget.mapData['idProduk'];
    namaProduk.text = widget.mapData['namaProduk'];
    hargaProduk.text = widget.mapData['hargaProduk'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Produk'),
        backgroundColor: Color.fromRGBO(255, 250, 237, 202),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: namaProduk,
                decoration: InputDecoration(
                  hintText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  if (value!.isEmpty) {
                    return "Nama produk tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: hargaProduk,
                decoration: InputDecoration(
                  hintText: 'Harga Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Harga produk tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 250, 237, 202),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final result = await ubah();
                      if (mounted) {
                        if (result) {
                          final snackBar = SnackBar(
                            content: Text('Data berhasil diubah!'),
                          );
                          scaffoldMessengerKey.currentState!.showSnackBar(
                            snackBar,
                          );
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Data gagal diubah!'),
                          );
                          scaffoldMessengerKey.currentState!.showSnackBar(
                            snackBar,
                          );
                        }
                      }
                    } catch (e) {
                      logger.e('Terjadi kesalahan: $e');
                    }
                    navigatorKey.currentState!.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HalamanProduk()),
                      (route) => false,
                    );
                  }
                },
                child: Text('Ubah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
