import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_assets.dart';
import 'filter_search_screen.dart';

class RequestCodeScreen extends StatefulWidget {
  const RequestCodeScreen({super.key});

  @override
  State<RequestCodeScreen> createState() => _RequestCodeScreenState();
}

class _RequestCodeScreenState extends State<RequestCodeScreen> {
  // Ecosystem languages
  final List<String> _languages = [
    'Laravel',
    'Flutter',
    'React',
    'Python AI / Tensor',
    'C++20 Embedded',
  ];
  String _selectedLanguage = 'Laravel';

  final TextEditingController _runtimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _resetForm() {
    setState(() {
      _runtimeController.clear();
      _titleController.clear();
      _descriptionController.clear();
      _emailController.clear();
      _selectedLanguage = 'Laravel';
      _selectedBudgetIndex = 1;
      _selectedTimeIndex = 1;
      _broadcastEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulir direset ke nilai awal'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Budget Bounty options
  int _selectedBudgetIndex = 1; // 1: Rp 500.000 (Paling Populer)
  final List<Map<String, String>> _budgetOptions = [
    {'tier': 'Skala Ringan', 'price': 'Rp 250.000'},
    {'tier': 'Paling Populer', 'price': 'Rp 500.000'},
    {'tier': 'Arsitektur Kompleks', 'price': 'Rp 1.000.000'},
    {'tier': 'Kustom / Nego', 'price': 'Bebas'},
  ];

  // Target waktu penyelesaian
  int _selectedTimeIndex = 1; // 1: 1 Minggu
  final List<String> _timeOptions = ['3 Hari', '1 Minggu', '2 Minggu', 'Fleksibel'];

  // Broadcast toggle
  bool _broadcastEnabled = true;

  @override
  void dispose() {
    _runtimeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  void _submitBounty() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permintaan Request Kode berhasil dipublikasikan!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  void _resetFormAndGoHome() {
    Navigator.of(context).pop();
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

            // Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner: Hasil Pencarian Kosong
                        _buildEmptySearchBanner(),
                        const SizedBox(height: 16),

                        // Section 1: Target Ekosistem & Bahasa
                        _buildEcosystemCard(),
                        const SizedBox(height: 16),

                        // Section 2: Spesifikasi Modul
                        _buildModuleSpecificationCard(),
                        const SizedBox(height: 16),

                        // Section 3: Budget Bounty
                        _buildBudgetBountyCard(),
                        const SizedBox(height: 16),

                        // Section 4: Target Waktu Penyelesaian
                        _buildTimelineCard(),
                        const SizedBox(height: 16),

                        // Section 5: Broadcast ke 150+ Necro Seller
                        _buildBroadcastCard(),
                        const SizedBox(height: 16),

                        // Section 6: NecroEngine AST Guarantee
                        _buildAstGuaranteeCard(),
                        const SizedBox(height: 20),

                        // Action Buttons: Kirim & Reset
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
              'Ajukan Request Kode',
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
            onPressed: _resetForm,
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

  Widget _buildEmptySearchBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  AppSvgIcon(
                    assetName: AppAssets.search2,
                    width: 17,
                    height: 16,
                    color: Color(0xFF0052CC),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'HASIL PENCARIAN KOSONG',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF334155),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '0 Hasil',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tidak menemukan paket yang cocok? Ajukan bounty arsitektur di bawah ini atau bersihkan filter pencarian untuk melihat semua modul warisan yang tersedia.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FilterSearchScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0052CC),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    icon: const AppSvgIcon(
                      assetName: AppAssets.riset,
                      width: 13,
                      height: 13,
                      color: Color(0xFF0052CC),
                    ),
                    label: const Text(
                      'Reset Filter & Pencarian',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0052CC),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    foregroundColor: const Color(0xFF475569),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  ),
                  icon: const Icon(Icons.explore_outlined,
                      size: 14, color: Color(0xFF475569)),
                  label: const Text(
                    'Katalog',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
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

  Widget _buildEcosystemCard() {
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
          const Row(
            children: [
              AppSvgIcon(
                assetName: AppAssets.web2,
                width: 16,
                height: 14,
                color: Color(0xFF0052CC),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Target Ekosistem & Bahasa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages.map((lang) {
              final isSelected = _selectedLanguage == lang;
              return GestureDetector(
                onTap: () => setState(() => _selectedLanguage = lang),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0052CC)
                        : const Color(0xFFF1F5FD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0052CC)
                          : Colors.transparent,
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
          const SizedBox(height: 14),

          // Framework / Runtime Spesifik
          const Text(
            'Framework / Runtime Spesifik',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const AppSvgIcon(
                  assetName: AppAssets.web2,
                  width: 15,
                  height: 13,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _runtimeController,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'mis. Tokio, Wasm-bindgen, Web-sys',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleSpecificationCard() {
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
          const Row(
            children: [
              AppSvgIcon(
                assetName: AppAssets.spesifikasi,
                width: 16,
                height: 16,
                color: Color(0xFF0052CC),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Spesifikasi Modul',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Judul Kebutuhan Kode
          const Text(
            'Judul Kebutuhan Kode',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'mis. Rust WASM Image Processing & Canvas Pipeline',
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Deskripsi Header Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Deskripsi Arsitektur & Kebutuhan Teknis',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Markdown Didukung',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textPrimary,
                fontFamily: 'monospace',
                height: 1.4,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Jelaskan kebutuhan teknis, arsitektur modul, performa target, atau API format (Markdown didukung)...',
                hintStyle: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontFamily: 'monospace',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Notice container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: Color(0xFF0052CC),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kode wajib menyertakan arsitektur headless tests dan dokumentasi API format Rustdoc.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF1E40AF),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBountyCard() {
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
          const Row(
            children: [
              AppSvgIcon(
                assetName: AppAssets.budget,
                width: 16,
                height: 16,
                color: Color(0xFF0052CC),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Budget Bounty',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2x2 Grid of budget options
          Row(
            children: [
              Expanded(child: _buildBudgetItem(0)),
              const SizedBox(width: 10),
              Expanded(child: _buildBudgetItem(1)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildBudgetItem(2)),
              const SizedBox(width: 10),
              Expanded(child: _buildBudgetItem(3)),
            ],
          ),
          const SizedBox(height: 12),

          // Smart Escrow Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSvgIcon(
                  assetName: AppAssets.look,
                  width: 13,
                  height: 15,
                  color: Color(0xFF0052CC),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dana bounty disimpan di Smart Escrow CodeNecromancer dan hanya dicairkan setelah kode lolos verifikasi kompilasi & AST Audit Engine.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF1E40AF),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(int index) {
    final opt = _budgetOptions[index];
    final isSelected = _selectedBudgetIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedBudgetIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0052CC)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    opt['tier']!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isSelected
                          ? const Color(0xFF0052CC)
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected && index == 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: Color(0xFF0052CC),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              opt['price']!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? const Color(0xFF0052CC)
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
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
          const Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Color(0xFF0052CC),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Target Waktu Penyelesaian',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Time tabs
          Row(
            children: List.generate(_timeOptions.length, (idx) {
              final isSelected = _selectedTimeIndex == idx;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: idx < _timeOptions.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTimeIndex = idx),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0052CC)
                            : const Color(0xFFF1F5FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _timeOptions[idx],
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Broadcast ke 150+ Necro Seller',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Notifikasi instan dikirim ke publisher terverifikasi.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _broadcastEnabled,
                activeColor: const Color(0xFF0052CC),
                onChanged: (val) => setState(() => _broadcastEnabled = val),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'GitHub Username / Email Alert',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const AppSvgIcon(
                  assetName: AppAssets.emailTerdaftar,
                  width: 17,
                  height: 16,
                  color: Color(0xFF737686),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'mis. alexander.dev@resurrect.io',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF94A3B8),
                        fontFamily: 'monospace',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstGuaranteeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0052CC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: AppSvgIcon(
                assetName: AppAssets.centang,
                width: 18,
                height: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NecroEngine AST Guarantee',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '100% bebas lisensi GPL tersembunyi, static analysis nol CVE kritis, serta garansi refunder 7 hari jika spesifikasi tidak terpenuhi.',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF475569),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Button 1: Kirim Permintaan & Buka Bounty
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: _submitBounty,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052CC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.bolt_rounded,
              size: 18,
              color: Colors.white,
            ),
            label: const Text(
              'Kirim Permintaan & Buka Bounty',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Button 2: Reset Formulir & Kembali ke Beranda
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: _resetFormAndGoHome,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF334155),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const AppSvgIcon(
              assetName: AppAssets.reload2,
              width: 13,
              height: 15,
              color: Color(0xFF475569),
            ),
            label: const Text(
              'Reset Formulir & Kembali ke Beranda',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
