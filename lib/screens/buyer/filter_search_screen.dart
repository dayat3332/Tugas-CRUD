import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_assets.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  final TextEditingController _keywordController = TextEditingController();

  final List<String> _languages = [
    'Rust',
    'PHP / Laravel',
    'Python (FastAPI / Django)',
    'JavaScript / TypeScript',
    'Flutter / Dart',
    'Go / Golang',
    'C++ / Systems',
  ];
  final Set<String> _selectedLanguages = {'Rust'};

  // Audit AST checkboxes
  bool _astVerifiedOnly = false;
  bool _healthScore100 = false;
  bool _docAndTestSuite = false;
  bool _readyCommercial = false;

  // Price range
  int _selectedQuickPriceIndex = 2; // 'Rp 200rb - 500rb'
  RangeValues _priceRange = const RangeValues(50000, 1500000);

  // Sorting
  int _selectedSortIndex = 0; // 0: Paling Populer & Terlaris

  int get _activeFilterCount {
    int count = 0;
    if (_keywordController.text.trim().isNotEmpty) count++;
    count += _selectedLanguages.length;
    if (_astVerifiedOnly) count++;
    if (_healthScore100) count++;
    if (_docAndTestSuite) count++;
    if (_readyCommercial) count++;
    return count;
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _resetAll() {
    setState(() {
      _keywordController.clear();
      _selectedLanguages.clear();
      _selectedLanguages.add('Rust');
      _astVerifiedOnly = false;
      _healthScore100 = false;
      _docAndTestSuite = false;
      _readyCommercial = false;
      _selectedQuickPriceIndex = 0;
      _priceRange = const RangeValues(0, 2000000);
      _selectedSortIndex = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter direset ke nilai awal'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _restoreDefaults() {
    setState(() {
      _keywordController.clear();
      _selectedLanguages.clear();
      _selectedLanguages.add('Rust');
      _astVerifiedOnly = false;
      _healthScore100 = false;
      _docAndTestSuite = false;
      _readyCommercial = false;
      _selectedQuickPriceIndex = 2;
      _priceRange = const RangeValues(50000, 1500000);
      _selectedSortIndex = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter dikembalikan ke pengaturan default'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _applyFilters() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter berhasil diterapkan (12 Hasil ditemukan)'),
        duration: Duration(seconds: 2),
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
            _buildTopBar(),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Kata Kunci Pencarian
                        _buildKeywordCard(),
                        const SizedBox(height: 16),

                        // Section 2: Ekosistem & Bahasa
                        _buildEcosystemCard(),
                        const SizedBox(height: 16),

                        // Section 3: Kualitas & Audit AST
                        _buildAstAuditCard(),
                        const SizedBox(height: 16),

                        // Section 4: Rentang Harga (IDR)
                        _buildPriceRangeCard(),
                        const SizedBox(height: 16),

                        // Section 5: Urutkan Hasil
                        _buildSortResultsCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Pinned Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            tooltip: 'Kembali',
          ),
          const Expanded(
            child: Text(
              'Filter & Pencarian',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: _restoreDefaults,
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0052CC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KATA KUNCI PENCARIAN',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),

          // Search Field Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const AppSvgIcon(
                  assetName: AppAssets.web2,
                  width: 17,
                  height: 14,
                  color: Color(0xFF0052CC),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _keywordController,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari kata kunci... (mis. Rust WebAssembly)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _keywordController.clear()),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_activeFilterCount Filter Aktif',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0052CC),
                  ),
                ),
              ),
              InkWell(
                onTap: _resetAll,
                child: const Row(
                  children: [
                    AppSvgIcon(
                      assetName: AppAssets.reload2,
                      width: 12,
                      height: 13,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Reset Semua',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEcosystemCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  AppSvgIcon(
                    assetName: AppAssets.chip,
                    width: 16,
                    height: 16,
                    color: Color(0xFF0052CC),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ekosistem & Bahasa',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Multi-pilih',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Language Chips Wrap
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedLanguages.length > 1) {
                      _selectedLanguages.remove(lang);
                    }
                  } else {
                    _selectedLanguages.add(lang);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0052CC) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0052CC)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(Icons.check, size: 14, color: Colors.white),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      lang,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAstAuditCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 17,
                    color: Color(0xFF00687A),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kualitas & Audit AST',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
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
                color: const Color(0xFFCCFBF1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Strict Standard',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F766E),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Checkbox Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Item 1: AST Verified Only
              _buildAuditCheckboxItem(
                checked: _astVerifiedOnly,
                onChanged: (val) =>
                    setState(() => _astVerifiedOnly = val ?? false),
                title: const Row(
                  children: [
                    Text(
                      'AST Verified Only',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 5),
                    AppSvgIcon(
                      assetName: AppAssets.centang2,
                      width: 14,
                      height: 14,
                      color: Color(0xFF00687A),
                    ),
                  ],
                ),
                subtitle:
                    'Static analysis penuh, zero critical CVE vulnerability.',
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Item 2: 100% Health Score
              _buildAuditCheckboxItem(
                checked: _healthScore100,
                onChanged: (val) =>
                    setState(() => _healthScore100 = val ?? false),
                title: const Text(
                  '100% Health Score',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle:
                    'Benchmark performa optimal tanpa memory leak terdeteksi.',
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Item 3: Dokumentasi & Test Suite
              _buildAuditCheckboxItem(
                checked: _docAndTestSuite,
                onChanged: (val) =>
                    setState(() => _docAndTestSuite = val ?? false),
                title: const Text(
                  'Dokumentasi & Test Suite',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle:
                    'Termasuk instruksi kompilasi, CI/CD script, dan unit tests.',
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Item 4: Siap Komersial
              _buildAuditCheckboxItem(
                checked: _readyCommercial,
                onChanged: (val) =>
                    setState(() => _readyCommercial = val ?? false),
                title: Row(
                  children: [
                    const Text(
                      'Siap Komersial',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Unrestricted',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle:
                    'Hak modifikasi penuh, distribusi komersil tanpa atribusi paksa.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuditCheckboxItem({
    required bool checked,
    required ValueChanged<bool?> onChanged,
    required Widget title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: checked ? const Color(0xFF0052CC) : const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(5),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                AppSvgIcon(
                  assetName: AppAssets.mataUang,
                  width: 18,
                  height: 13,
                  color: Color(0xFF0052CC),
                ),
                SizedBox(width: 8),
                Text(
                  'Rentang Harga\n(IDR)',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Text(
              'Rp ${_formatPrice(_priceRange.start.toInt())} - Rp\n${_formatPrice(_priceRange.end.toInt())}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0052CC),
                fontFamily: 'monospace',
                height: 1.25,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quick Price Chips 2x2 Grid
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildQuickPriceBtn(
                      label: 'Semua Harga',
                      index: 0,
                      onTap: () {
                        setState(() {
                          _selectedQuickPriceIndex = 0;
                          _priceRange = const RangeValues(0, 2000000);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickPriceBtn(
                      label: '< Rp 200rb',
                      index: 1,
                      onTap: () {
                        setState(() {
                          _selectedQuickPriceIndex = 1;
                          _priceRange = const RangeValues(0, 200000);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickPriceBtn(
                      label: 'Rp 200rb - 500rb',
                      index: 2,
                      onTap: () {
                        setState(() {
                          _selectedQuickPriceIndex = 2;
                          _priceRange = const RangeValues(200000, 500000);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickPriceBtn(
                      label: '> Rp 500rb',
                      index: 3,
                      onTap: () {
                        setState(() {
                          _selectedQuickPriceIndex = 3;
                          _priceRange = const RangeValues(500000, 2000000);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Range Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF0052CC),
                  inactiveTrackColor: const Color(0xFFDBEAFE),
                  trackHeight: 5,
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                    elevation: 2,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                ),
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 2000000,
                  divisions: 40,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                      _selectedQuickPriceIndex = -1;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Min and Max Price Info Boxes
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harga Terendah',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Rp  ${_formatPrice(_priceRange.start.toInt())}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harga Maksimal',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Rp  ${_formatPrice(_priceRange.end.toInt())}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPriceBtn({
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedQuickPriceIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortResultsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 18,
                    color: Color(0xFF0052CC),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Urutkan Hasil',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Prioritas Algoritma',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sort Options Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Option 0: Paling Populer & Terlaris
              _buildSortOption(
                index: 0,
                title: 'Paling Populer & Terlaris',
                icon: const AppSvgIcon(
                  assetName: AppAssets.api,
                  width: 16,
                  height: 16,
                  color: Color(0xFF0052CC),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Option 1: Terbaru Diunggah
              _buildSortOption(
                index: 1,
                title: 'Terbaru Diunggah',
                icon: const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Option 2: Harga: Rendah ke Tinggi
              _buildSortOption(
                index: 2,
                title: 'Harga: Rendah ke Tinggi',
                icon: const AppSvgIcon(
                  assetName: AppAssets.hargaRendah,
                  width: 16,
                  height: 16,
                  color: Color(0xFF64748B),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Option 3: Health Score Tertinggi
              _buildSortOption(
                index: 3,
                title: 'Health Score Tertinggi',
                icon: const AppSvgIcon(
                  assetName: AppAssets.helt,
                  width: 16,
                  height: 16,
                  color: Color(0xFF00687A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOption({
    required int index,
    required String title,
    required Widget icon,
  }) {
    final isSelected = _selectedSortIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedSortIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0052CC)
                      : const Color(0xFF94A3B8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0052CC),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          // Default Button
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _restoreDefaults,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
                foregroundColor: const Color(0xFF1E293B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              icon: const AppSvgIcon(
                assetName: AppAssets.defaultFilter,
                width: 16,
                height: 16,
                color: Color(0xFF334155),
              ),
              label: const Text(
                'Default',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Terapkan (12 Hasil) Button
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const AppSvgIcon(
                  assetName: AppAssets.terapkan,
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  'Terapkan (12 Hasil)',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
