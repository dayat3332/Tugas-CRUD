import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_assets.dart';
import 'widgets/category_chips.dart';
import 'navigation/bottom_nav_bar.dart';
import 'widgets/app_top_bar.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/buyer/wishlist_screen.dart';
import 'screens/buyer/library_screen.dart';
import 'screens/buyer/orders_screen.dart' show OrdersScreen;
import 'screens/seller/sell_screen.dart' show SellScreen;
import 'screens/profile_screen.dart';
import 'screens/buyer/filter_search_screen.dart';
import 'screens/buyer/request_code_screen.dart';
import 'models/blueprint_model.dart';
import 'services/blueprint_service.dart';
import 'screens/blueprint_form_screen.dart';
import 'config/api_config.dart';
import 'ip_detail_screen.dart';

void main() {
  runApp(const CodeNecromancerApp());
}

class CodeNecromancerApp extends StatelessWidget {
  final String initialRoute;
  const CodeNecromancerApp({super.key, this.initialRoute = '/'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeNecromancer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SplashScreen(),
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MarketplaceDashboard(),
        '/wishlist': (context) => const WishlistScreen(),
        '/library': (context) => const LibraryScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/sell': (context) => const SellScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/filter': (context) => const FilterSearchScreen(),
        '/request-code': (context) => const RequestCodeScreen(),
      },
    );
  }
}

class MarketplaceDashboard extends StatefulWidget {
  const MarketplaceDashboard({super.key});

  @override
  State<MarketplaceDashboard> createState() => _MarketplaceDashboardState();
}

class _MarketplaceDashboardState extends State<MarketplaceDashboard> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController =
      TextEditingController(text: '');
  String _selectedSort = 'Populer';

  final List<String> _popularTags = ['Laravel', 'Next.js', 'Flutter', 'FastAPI'];

  final BlueprintService _blueprintService = BlueprintService();
  List<BlueprintModel> _blueprints = [];
  bool _isLoading = true;
  bool _isBackendConnected = false;

  @override
  void initState() {
    super.initState();
    _loadBlueprints();
  }

  Future<void> _loadBlueprints() async {
    setState(() => _isLoading = true);
    final isOnline = await _blueprintService.isBackendConnected();
    final data = await _blueprintService.getBlueprints();
    if (!mounted) return;
    setState(() {
      _isBackendConnected = isOnline;
      _blueprints = data;
      _isLoading = false;
    });
  }

  List<BlueprintModel> get _filteredBlueprints {
    List<BlueprintModel> list = List.from(_blueprints);

    // Filter kategori berdasarkan chip:
    // 0: Semua, 1: Populer, 2: Frontend, 3: Backend, 4: Mobile, 5: AI/ML
    if (_selectedCategoryIndex == 1) {
      list = list.where((b) {
        final l = b.stackLabel.toLowerCase();
        return l.contains('laravel') ||
            l.contains('next') ||
            l.contains('flutter') ||
            l.contains('fastapi');
      }).toList();
    } else if (_selectedCategoryIndex == 2) {
      list = list.where((b) {
        final l = b.stackLabel.toLowerCase();
        return l.contains('next') || l.contains('react');
      }).toList();
    } else if (_selectedCategoryIndex == 3) {
      list = list.where((b) {
        final l = b.stackLabel.toLowerCase();
        return l.contains('laravel') || l.contains('fastapi');
      }).toList();
    } else if (_selectedCategoryIndex == 4) {
      list = list.where((b) => b.stackLabel.toLowerCase().contains('flutter')).toList();
    } else if (_selectedCategoryIndex == 5) {
      list = list.where((b) {
        final l = b.stackLabel.toLowerCase();
        return l.contains('ai') || l.contains('python');
      }).toList();
    }

    // Filter teks pencarian
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((b) {
        return b.title.toLowerCase().contains(query) ||
            b.author.toLowerCase().contains(query) ||
            b.stackLabel.toLowerCase().contains(query) ||
            b.description.toLowerCase().contains(query);
      }).toList();
    }

    // Urutkan
    if (_selectedSort == 'Terbaru') {
      list.sort((a, b) =>
          (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    }

    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Widget Extraction via fungsi _buildItemCard
  Widget _buildItemCard({
    required String title,
    required String author,
    required String price,
    required String stackLabel,
    required String stackSvg,
    required VoidCallback onTap,
  }) {
    return ItemCardWidget(
      title: title,
      author: author,
      price: price,
      stackLabel: stackLabel,
      stackSvg: stackSvg,
      onTap: onTap,
    );
  }

  void _resetFilter() {
    setState(() {
      _selectedCategoryIndex = 0;
      _searchController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter dan pencarian direset ke default'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _selectTag(String tag) {
    setState(() {
      _searchController.text = tag;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mencari blueprint untuk $tag'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Urutkan Blueprint',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading:
                      const Icon(Icons.trending_up, color: AppColors.primary),
                  title: const Text('Populer'),
                  trailing: _selectedSort == 'Populer'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedSort = 'Populer');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.new_releases_outlined,
                      color: AppColors.primary),
                  title: const Text('Terbaru'),
                  trailing: _selectedSort == 'Terbaru'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedSort = 'Terbaru');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.star_outline, color: AppColors.primary),
                  title: const Text('Rating Tertinggi'),
                  trailing: _selectedSort == 'Rating Tertinggi'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedSort = 'Rating Tertinggi');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
              onProfileTap: () => Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ProfileScreen(),
                  transitionDuration: Duration.zero,
                ),
              ),
            ),

            // Content Area with Pull-To-Refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadBlueprints,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Text
                          _buildHeroSection(),
                          const SizedBox(height: 14),

                          // Docker Backend Connection Status Card
                          _buildDockerStatusBar(),
                          const SizedBox(height: 16),

                          // Search Bar & Filter Button
                          _buildSearchAndFilter(),
                          const SizedBox(height: 18),

                          // Horizontal Category Chips
                          CategoryChips(
                            selectedIndex: _selectedCategoryIndex,
                            onSelected: (index) {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          ),
                          const SizedBox(height: 24),

                          // Section Title: Featured Blueprints & Sort By
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Featured Blueprints',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showSortDialog,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Sort By',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Dynamic Blueprints List from Docker Database
                          if (_isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else
                            ..._filteredBlueprints.map((bp) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _buildItemCard(
                                  title: bp.title,
                                  author: bp.author,
                                  price: bp.price,
                                  stackLabel: bp.stackLabel,
                                  stackSvg: bp.stackSvg,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => IPDetailScreen(
                                          title: bp.title,
                                          author: bp.author,
                                          price: bp.price,
                                          blueprint: bp,
                                        ),
                                      ),
                                    ).then((v) {
                                      if (v == true) _loadBlueprints();
                                    });
                                  },
                                ),
                              );
                            }),
                          const SizedBox(height: 18),

                          // Main Card: Empty Blueprint / Request Code Card
                          _buildEmptyStateCard(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            BottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) return;
                Widget target;
                switch (index) {
                  case 1:
                    target = const WishlistScreen();
                    break;
                  case 2:
                    target = const LibraryScreen();
                    break;
                  case 3:
                    target = const ProfileScreen();
                    break;
                  default:
                    target = const MarketplaceDashboard();
                }
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => target,
                    transitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDockerStatusBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isBackendConnected
            ? const Color(0xFFF0FDF4)
            : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isBackendConnected
              ? const Color(0xFFBBF7D0)
              : const Color(0xFFFED7AA),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isBackendConnected
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFEA580C),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isBackendConnected
                          ? 'Docker MySQL API: Online (${_blueprints.length} Data)'
                          : 'Docker MySQL API: Offline (Fallback)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _isBackendConnected
                            ? const Color(0xFF15803D)
                            : const Color(0xFFC2410C),
                      ),
                    ),
                    Text(
                      'Host: ${ApiConfig.baseUrl}',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontFamily: 'monospace',
                        color: _isBackendConnected
                            ? const Color(0xFF166534)
                            : const Color(0xFF9A3412),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: AppColors.textSecondary,
                onPressed: _loadBlueprints,
                tooltip: 'Muat ulang data dari Docker',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BlueprintFormScreen(),
                        ),
                      );
                      if (res == true) _loadBlueprints();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      'Tambah',
                      style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SellScreen()),
                      ).then((_) => _loadBlueprints());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.inventory_2_outlined, size: 15, color: AppColors.primary),
                    label: const Text(
                      'Kelola CRUD',
                      style: TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showConfigureHostDialog,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('IP', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfigureHostDialog() {
    final controller = TextEditingController(text: ApiConfig.host);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfigurasi Host Docker API',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gunakan 10.0.2.2 untuk Android Emulator, 127.0.0.1 untuk Linux Desktop/Chrome, atau IP Wi-Fi (misal: 192.168.0.150) jika menjalankan di HP fisik Android.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Host / IP Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ApiConfig.resetHost();
              Navigator.pop(ctx);
              _loadBlueprints();
            },
            child: const Text('Reset Default'),
          ),
          ElevatedButton(
            onPressed: () {
              ApiConfig.setHost(controller.text.trim());
              Navigator.pop(ctx);
              _loadBlueprints();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCodePromoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code_rounded,
                    color: Color(0xFF38BDF8), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Butuh Arsitektur Khusus?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Ajukan Request Code Bounty untuk repositori dan stack khusus yang akan digarap oleh kurator CodeNecromancer.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RequestCodeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Ajukan Request Code',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revive & Ship',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        Text(
          'Production Code',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Curated, audited repositories engineered for instant deployment.',
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search templates, full-stack rep',
                      hintStyle: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FilterSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                ),
              ),
              const AppSvgIcon(
                assetName: AppAssets.emptyBlueprint,
                width: 38,
                height: 38,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 14,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Tidak Ada Blueprint yang Cocok',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Kami tidak dapat menemukan blueprint atau repositori yang cocok dengan filter atau kata kunci saat ini. Coba ganti filter stack atau cari kata kunci lain.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _resetFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh_rounded, size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Reset Filter & Pencarian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RequestCodeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFF6FF),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Ajukan Request Kode',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          const Text(
            'Coba cari stack populer:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _popularTags.map((tag) {
              String? tagSvg;
              if (tag == 'Laravel') tagSvg = AppAssets.laravel;
              if (tag == 'Next.js') tagSvg = AppAssets.nextjs;
              if (tag == 'FastAPI') tagSvg = AppAssets.python;

              return GestureDetector(
                onTap: () => _selectTag(tag),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tagSvg != null) ...[
                        AppSvgIcon(assetName: tagSvg, width: 14, height: 14),
                        const SizedBox(width: 6),
                      ] else if (tag == 'Flutter') ...[
                        const Icon(Icons.flutter_dash,
                            size: 14, color: Color(0xFF02569B)),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Widget Extraction via Class Terpisah (ItemCardWidget)
class ItemCardWidget extends StatelessWidget {
  final String title;
  final String author;
  final String price;
  final String stackLabel;
  final String stackSvg;
  final VoidCallback onTap;

  const ItemCardWidget({
    super.key,
    required this.title,
    required this.author,
    required this.price,
    required this.stackLabel,
    required this.stackSvg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvgIcon(assetName: stackSvg, width: 14, height: 14),
                        const SizedBox(width: 6),
                        Text(
                          stackLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AST Verified',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Publisher: $author',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: Color(0xFFF1F5F9)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Akuisisi Lisensi',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Inspect IP',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
