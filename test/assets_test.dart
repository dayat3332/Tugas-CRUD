import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_necromancer/constants/app_assets.dart';

void main() {
  testWidgets('AppSvgIcon renders SVG assets without errors',
      (WidgetTester tester) async {
    const assetsToTest = [
      AppAssets.github,
      AppAssets.google,
      AppAssets.email,
      AppAssets.lock,
      AppAssets.arrowForward,
      AppAssets.navHome,
      AppAssets.navOrders,
      AppAssets.navSell,
      AppAssets.navWishlist,
      AppAssets.navLibrary,
      AppAssets.wislit,
      AppAssets.pustaka,
      AppAssets.book,
      AppAssets.simpan,
      AppAssets.jelajah,
      AppAssets.pustakaKode,
      AppAssets.lampu,
      AppAssets.lonceng,
      AppAssets.diskon,
      AppAssets.racangan,
      AppAssets.repo,
      AppAssets.asetKode,
      AppAssets.gitBelumAda,
      AppAssets.look,
      AppAssets.tandaTanya,
      AppAssets.coding,
      AppAssets.emptyBlueprint,
      AppAssets.nextjs,
      AppAssets.react,
      AppAssets.laravel,
      AppAssets.python,
      AppAssets.riset,
      AppAssets.defaultFilter,
      AppAssets.terapkan,
      AppAssets.budget,
      AppAssets.centang,
      AppAssets.centang2,
      AppAssets.chip,
      AppAssets.mataUang,
      AppAssets.spesifikasi,
      AppAssets.api,
      AppAssets.helt,
      AppAssets.hargaRendah,
      AppAssets.coding2,
      AppAssets.web2,
      AppAssets.search2,
      AppAssets.reload2,
      AppAssets.emailTerdaftar,
    ];

    for (final asset in assetsToTest) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppSvgIcon(
                assetName: asset,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AppSvgIcon), findsOneWidget);
    }
  });

  testWidgets('App Logo and Blueprint PNG assets render without errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Image.asset(AppAssets.logo),
              Image.asset(AppAssets.blueprintIllustration),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(Image), findsNWidgets(2));
  });
}
