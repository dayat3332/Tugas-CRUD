import 'package:flutter_test/flutter_test.dart';
import 'package:app_produk/main.dart';
import 'package:app_produk/halaman_produk.dart';

void main() {
  testWidgets('App smoke test: memverifikasi HalamanProduk terpasang', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(HalamanProduk), findsOneWidget);
  });
}
