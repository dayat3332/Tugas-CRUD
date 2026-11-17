import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  AppAssets._();

  // Logos & Illustrations
  static const String logo = 'image/CodeNecromancer Logo.png';
  static const String logoPng = 'image/CodeNecromancer Logo.png';
  static const String logoLegacy = 'image/codenecromancer_logo.png';
  static const String logoSvg = 'image/CodeNecromancer Logo.svg';
  static const String blueprintIllustration = 'image/blueprint_illustration.png';
  static const String blueprintIllustrationSvg = 'image/image 1.svg';

  // Social
  static const String github = 'image/SVG.svg';
  static const String google = 'image/SVG (1).svg';

  // Form & Common Icons
  static const String email = 'image/Icon.svg';
  static const String lock = 'image/Icon (1).svg';
  static const String arrowForward = 'image/Icon (2).svg';

  // Navigation
  static const String navHome = 'image/Container (1).svg';
  static const String navOrders = 'image/Icon (3).svg';
  static const String navSell = 'image/Icon (4).svg';
  static const String navProfile = 'image/Icon (5).svg';
  static const String navWishlist = 'image/wislit.svg';
  static const String navLibrary = 'image/pustaka.svg';

  // Wishlist & Library Screens
  static const String wislit = 'image/wislit.svg';
  static const String pustaka = 'image/pustaka.svg';
  static const String book = 'image/book.svg';
  static const String simpan = 'image/simpan.svg';
  static const String jelajah = 'image/jelajah.svg';
  static const String pustakaKode = 'image/pustaka_kode.svg';
  static const String lampu = 'image/lampu.svg';
  static const String lonceng = 'image/lonceng.svg';
  static const String diskon = 'image/diskon.svg';
  static const String racangan = 'image/racangan.svg';
  static const String repo = 'image/repo.svg';
  static const String asetKode = 'image/aset_kode.svg';
  static const String gitBelumAda = 'image/git_belumada.svg';
  static const String look = 'image/look.svg';
  static const String tandaTanya = 'image/tanda_tanya.svg';
  static const String coding = 'image/coding.svg';

  // Empty State
  static const String emptyBlueprint = 'image/Container.svg';

  // Stacks & Technologies
  static const String nextjs = 'image/Symbol.svg.svg';
  static const String react = 'image/Page-1.svg';
  static const String laravel = 'image/laravel_symbol.svg.svg';
  static const String python = 'image/python_software_foundation_logo.svg.svg';

  // Filter & Request Code Screens
  static const String riset = 'image/riset.svg';
  static const String defaultFilter = 'image/default.svg';
  static const String terapkan = 'image/terapkan.svg';
  static const String budget = 'image/budget.svg';
  static const String centang = 'image/centang.svg';
  static const String centang2 = 'image/centang2.svg';
  static const String chip = 'image/chip.svg';
  static const String mataUang = 'image/mata_uang.svg';
  static const String spesifikasi = 'image/spesifikasi.svg';
  static const String api = 'image/api.svg';
  static const String helt = 'image/helt.svg';
  static const String hargaRendah = 'image/harga-rendah.svg';
  static const String coding2 = 'image/coding.svg';
  static const String web2 = 'image/web2.svg';
  static const String emailTerdaftar = 'image/email_terdaftar.svg';
  static const String search2 = 'image/search2.svg';
  static const String reload = 'image/reload2.svg';
  static const String reload2 = 'image/reload2.svg';
}

/// A convenient widget to render SVG assets with consistent size and color.
class AppSvgIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppSvgIcon({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => SizedBox(
        width: width ?? 20,
        height: height ?? 20,
      ),
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: width ?? 20,
        height: height ?? 20,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: (width != null && height != null)
              ? (width! < height! ? width! : height!) * 0.8
              : 18,
          color: color ?? const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
