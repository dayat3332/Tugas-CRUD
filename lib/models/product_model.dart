import '../utils/currency_formatter.dart';

/// Model Produk dengan pendekatan PBO (Pemrograman Berorientasi Objek).
/// Mengenkapsulasi atribut data produk, konversi JSON, dan method utilitasnya.
class Product {
  final int? idProduk;
  final String namaProduk;
  final int hargaProduk;
  final String? gambarProduk;
  final String? deskripsiProduk;

  const Product({
    this.idProduk,
    required this.namaProduk,
    required this.hargaProduk,
    this.gambarProduk,
    this.deskripsiProduk,
  });

  /// Factory constructor untuk mem-parse JSON dari API PHP
  factory Product.fromJson(Map<String, dynamic> json) {
    // Robust parsing untuk menangani tipe data string atau int dari PHP/MySQL
    int? parsedId;
    if (json['id_produk'] != null) {
      parsedId = int.tryParse(json['id_produk'].toString());
    }

    int parsedHarga = 0;
    if (json['harga_produk'] != null) {
      parsedHarga = int.tryParse(json['harga_produk'].toString()) ?? 0;
    }

    return Product(
      idProduk: parsedId,
      namaProduk: json['nama_produk']?.toString() ?? '',
      hargaProduk: parsedHarga,
      gambarProduk: json['gambar_produk']?.toString().isNotEmpty == true
          ? json['gambar_produk'].toString()
          : null,
      deskripsiProduk: json['deskripsi_produk']?.toString().isNotEmpty == true
          ? json['deskripsi_produk'].toString()
          : null,
    );
  }

  /// Konversi object Product ke Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (idProduk != null) 'id_produk': idProduk,
      'nama_produk': namaProduk,
      'harga_produk': hargaProduk,
      if (gambarProduk != null) 'gambar_produk': gambarProduk,
      if (deskripsiProduk != null) 'deskripsi_produk': deskripsiProduk,
    };
  }

  /// Konversi data ke format `Map<String, dynamic>` untuk dikirim via POST Form-Data ke PHP
  Map<String, dynamic> toFormData() {
    final map = <String, dynamic>{
      'nama_produk': namaProduk,
      'harga_produk': hargaProduk.toString(),
      'gambar_produk': gambarProduk ?? '',
      'deskripsi_produk': deskripsiProduk ?? '',
    };
    if (idProduk != null) {
      map['id_produk'] = idProduk.toString();
    }
    return map;
  }

  /// Getter untuk format harga dalam Rupiah (IDR)
  String get formattedPrice => CurrencyFormatter.formatToRupiah(hargaProduk);

  /// Method copyWith untuk membuat objek baru dengan perubahan parsial
  Product copyWith({
    int? idProduk,
    String? namaProduk,
    int? hargaProduk,
    String? gambarProduk,
    String? deskripsiProduk,
  }) {
    return Product(
      idProduk: idProduk ?? this.idProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      hargaProduk: hargaProduk ?? this.hargaProduk,
      gambarProduk: gambarProduk ?? this.gambarProduk,
      deskripsiProduk: deskripsiProduk ?? this.deskripsiProduk,
    );
  }

  @override
  String toString() {
    return 'Product(id: $idProduk, nama: $namaProduk, harga: $hargaProduk)';
  }
}
