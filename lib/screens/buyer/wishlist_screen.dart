import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_assets.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../widgets/app_top_bar.dart';
import '../profile_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  void _navigateToTab(int index) {
    if (index == 1) return; // already on Wishlist
    Widget target;
    switch (index) {
      case 0:
        target = const HomeScreen();
        break;
      case 2:
        target = const LibraryScreen();
        break;
      case 3:
        target = const ProfileScreen();
        break;
      default:
        target = const HomeScreen();
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            AppTopBar(
              onProfileTap: () => _navigateToTab(3),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(),
                        const SizedBox(height: 18),

                        // Perkiraan Anggaran Sprint Card
                        _buildBudgetCard(),
                        const SizedBox(height: 18),

                        // Wishlist Kosong Card
                        _buildEmptyWishlistCard(),
                        const SizedBox(height: 18),

                        // Kenapa Menggunakan Wishlist Card
                        _buildWhyWishlistCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar (Tab 1: Wishlist is active)
            BottomNavBar(
              currentIndex: 1,
              onTap: _navigateToTab,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              'Wishlist Proyek',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '0 Proyek',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Simpan repositori dan blueprint arsitektur favorit Anda untuk dibeli nanti saat sprint atau anggaran siap.',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.credit_card_rounded,
                      size: 18,
                      color: Color(0xFF0052CC),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'PERKIRAAN ANGGARAN SPRINT',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Kosong',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two Sub-boxes Row
          Row(
            children: [
              // Estimasi Total Budget
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimasi Total Budget',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Rp 0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF94A3B8),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              '0 Blueprint terpilih',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Potongan / Hemat
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Potongan / Hemat',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Rp 0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00687A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const AppSvgIcon(
                            assetName: AppAssets.diskon,
                            width: 10,
                            height: 10,
                            color: Color(0xFF00687A),
                          ),
                          const SizedBox(width: 5),
                          const Flexible(
                            child: Text(
                              'Diskon bundle pasif',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Footer Status
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF64748B),
                  shape: BoxShape.circle,
                ),
              ),
              const Text(
                'Status: Belum Ada Blueprint Disimpan',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'IDR-SYC : READY',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlistCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Illustration Stack
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer gray circle
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                ),
                // Inner white circle with bookmark
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: AppSvgIcon(
                      assetName: AppAssets.wislit,
                      width: 22,
                      height: 27,
                      color: Color(0xFF004AC6),
                    ),
                  ),
                ),
                // Top-right blue coding badge
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF004AC6),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AppSvgIcon(
                        assetName: AppAssets.coding,
                        width: 12,
                        height: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Bottom-left cyan spark badge
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Wishlist Anda Masih Kosong',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          const Text(
            'Belum ada blueprint atau repositori yang Anda tandai. Jelajahi katalog source code dan simpan modul terbaik untuk kebutuhan proyek Anda.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Button 1: Jelajahi Marketplace
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _navigateToTab(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004AC6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const AppSvgIcon(
                assetName: AppAssets.jelajah,
                width: 17,
                height: 17,
                color: Colors.white,
              ),
              label: const Text(
                'Jelajahi Marketplace',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Button 2: Lihat Pustaka Kode
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _navigateToTab(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5FD),
                foregroundColor: const Color(0xFF1E293B),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const AppSvgIcon(
                assetName: AppAssets.pustakaKode,
                width: 17,
                height: 14,
                color: Color(0xFF434655),
              ),
              label: const Text(
                'Lihat Pustaka Kode',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyWishlistCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const AppSvgIcon(
                assetName: AppAssets.lampu,
                width: 13,
                height: 17,
                color: Color(0xFF004AC6),
              ),
              const Expanded(
                child: Text(
                  'Kenapa Menggunakan Wishlist?',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Feature 1: Pantau Penurunan Harga & Flash Sale
          _buildFeatureCard(
            iconAsset: AppAssets.lonceng,
            iconWidth: 15,
            iconHeight: 16,
            iconColor: const Color(0xFF004AC6),
            circleBg: const Color(0xFFF1F5F9),
            title: 'Pantau Penurunan Harga & Flash Sale',
            description:
                'Dapatkan notifikasi instan saat blueprint incaran Anda sedang diskon atau memperoleh update lisensi.',
          ),
          const SizedBox(height: 10),

          // Feature 2: Bundle Checkout Lebih Hemat
          _buildFeatureCard(
            iconAsset: AppAssets.diskon,
            iconWidth: 12,
            iconHeight: 12,
            iconColor: const Color(0xFF00687A),
            circleBg: const Color(0xFFF1F5F9),
            title: 'Bundle Checkout Lebih Hemat',
            description:
                'Beli beberapa repositori sekaligus untuk mengaktifkan potongan bundle arsitektur secara otomatis.',
          ),
          const SizedBox(height: 10),

          // Feature 3: Rencana Arsitektur Sprint
          _buildFeatureCard(
            iconAsset: AppAssets.racangan,
            iconWidth: 15,
            iconHeight: 14,
            iconColor: const Color(0xFF4338D9),
            circleBg: const Color(0xFFF1F5F9),
            title: 'Rencana Arsitektur Sprint',
            description:
                'Kelompokkan blueprint modular yang dibutuhkan untuk estimasi kebutuhan teknis proyek klien mendatang.',
          ),
          const SizedBox(height: 14),

          // Hint Footer
          Row(
            children: [
              const Icon(
                Icons.touch_app_outlined,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                    children: [
                      TextSpan(text: 'Tekan ikon bookmark '),
                      TextSpan(
                        text: 'pada repositori mana pun',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                      TextSpan(text: ' untuk menambahkannya.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String iconAsset,
    required double iconWidth,
    required double iconHeight,
    required Color iconColor,
    required Color circleBg,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppSvgIcon(
                assetName: iconAsset,
                width: iconWidth,
                height: iconHeight,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
