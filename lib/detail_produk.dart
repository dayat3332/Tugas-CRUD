import 'package:flutter/material.dart';

class DetailProduk extends StatelessWidget {
  final Map mapData;
  const DetailProduk({super.key, required this.mapData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
        backgroundColor: Color.fromRGBO(255, 250, 237, 202),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('ID Produk'),
                  subtitle: Text(mapData['idProduk']),
                ),
                ListTile(
                  title: Text('Nama Produk'),
                  subtitle: Text(mapData['namaProduk']),
                ),
                ListTile(
                  title: Text('Harga Produk'),
                  subtitle: Text(mapData['hargaProduk']),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
