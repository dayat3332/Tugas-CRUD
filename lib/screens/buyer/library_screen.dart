import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_assets.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../widgets/app_top_bar.dart';
import '../profile_screen.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  void _navigateToTab(int index) {
    if (index == 2) return; // already on Library
    Widget target;
    switch (index) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = const WishlistScreen();
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

                        // 3 Stat Boxes Row
                        _buildStatBoxesRow(),
                        const SizedBox(height: 18),

                        // Empty Brankas Grimoire Card
                        _buildEmptyGrimoireCard(),
                        const SizedBox(height: 18),

                        // Cara Kerja Grimoire Guide Card
                        _buildGrimoireGuideCard(),
                        const SizedBox(height: 16),

                        // Guarantee Notice
                        _buildGuaranteeNotice(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar (Tab 2: Library is active)
            BottomNavBar(
              currentIndex: 2,
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
          children: [
            const AppSvgIcon(
              assetName: AppAssets.pustaka,
              width: 22,
              height: 20,
              color: Color(0xFF0052CC),
            ),
            const Text(
              'Pustaka Repositori',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Brankas kode produksi yang lunas dibeli. Akses download .zip dan repositori GitHub resmi akan otomatis terbuka di sini setelah transaksi selesai.',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBoxesRow() {
    return Row(
      children: [
        // Box 1: Repositori
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Repositori',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppSvgIcon(
                      assetName: AppAssets.repo,
                      width: 13,
                      height: 13,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '0',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Dimiliki',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Box 2: Aset Kode
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Aset Kode',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppSvgIcon(
                      assetName: AppAssets.asetKode,
                      width: 13,
                      height: 13,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Rp 0',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Valuasi',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Box 3: GitHub
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'GitHub',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppSvgIcon(
                      assetName: AppAssets.gitBelumAda,
                      width: 13,
                      height: 13,
                      color: Color(0xFF00687A),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Offline',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Sync Belum Aktif',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyGrimoireCard() {
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
          // Illustration Stack: circle with open book and lock badge
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: AppSvgIcon(
                      assetName: AppAssets.book,
                      width: 32,
                      height: 24,
                      color: Color(0xFF004AC6),
                    ),
                  ),
                ),
                // Lock badge at bottom right of book
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF004AC6),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AppSvgIcon(
                        assetName: AppAssets.look,
                        width: 9,
                        height: 12,
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
            'Brankas Grimoire Anda Masih\nKosong',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          const Text(
            'Anda belum membeli blueprint atau source code arsitektur apapun. Semua repositori yang Anda beli akan mendapatkan akses download .zip instan, undangan kolaborator GitHub seumur hidup, dan audit kode AST terverifikasi.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Button 1: Jelajahi Blueprint di Marketplace
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
                'Jelajahi Blueprint di Marketplace',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Button 2: Cek Wishlist Proyek Tersimpan
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                _navigateToTab(1);
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
                assetName: AppAssets.simpan,
                width: 12,
                height: 15,
                color: Color(0xFF004AC6),
              ),
              label: const Text(
                'Cek Wishlist Proyek Tersimpan',
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

  Widget _buildGrimoireGuideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const AppSvgIcon(
                assetName: AppAssets.tandaTanya,
                width: 16,
                height: 16,
                color: Color(0xFF00687A),
              ),
              const Expanded(
                child: Text(
                  'Bagaimana Cara Kerja Grimoire?',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Step 1: Beli Blueprint
          _buildStepRow(
            number: '1',
            title: 'Beli Blueprint',
            subtitle:
                'Pilih arsitektur teruji, lakukan pembayaran instan dalam Rupiah via QRIS atau Virtual Account.',
          ),
          const SizedBox(height: 14),

          // Step 2: Akses Otomatis
          _buildStepRow(
            number: '2',
            title: 'Akses Otomatis',
            subtitle:
                'Tombol unduh bundle .zip dan undangan hak akses repositori private GitHub langsung aktif tanpa verifikasi manual.',
          ),
          const SizedBox(height: 14),

          // Step 3: Update Seumur Hidup
          _buildStepRow(
            number: '3',
            title: 'Update Seumur Hidup',
            subtitle:
                'Terima sync perbaikan bug, patch keamanan, dan upgrade framework versi terbaru dari author secara gratis selamanya.',
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0052CC),
              ),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
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
    );
  }

  Widget _buildGuaranteeNotice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 16,
          color: Color(0xFF0052CC),
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Transaksi bergaransi & source code diaudit otomatis oleh CodeNecromancer.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF475569),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
