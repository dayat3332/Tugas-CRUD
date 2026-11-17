import 'package:intl/intl.dart';

/// Utilitas pemformatan mata uang Rupiah (IDR).
/// Menggunakan package intl untuk memastikan pemformatan sesuai standar Indonesia.
class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Memformat angka ke format Rupiah, contoh: 50000 -> "Rp 50.000"
  static String formatToRupiah(num? amount) {
    if (amount == null) return 'Rp 0';
    return _formatter.format(amount);
  }

  /// Mem-parse string harga input menjadi integer murni
  static int parseRupiah(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}
