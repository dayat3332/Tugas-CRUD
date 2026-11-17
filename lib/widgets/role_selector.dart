import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RoleSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Peran Utama Anda',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildRoleTab(
                  index: 0,
                  label: 'Buyer / Developer',
                  icon: Icons.file_download_outlined,
                  isSelected: selectedIndex == 0,
                ),
              ),
              Expanded(
                child: _buildRoleTab(
                  index: 1,
                  label: 'Seller / Publisher',
                  icon: Icons.file_upload_outlined,
                  isSelected: selectedIndex == 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          selectedIndex == 0
              ? 'Akses repositori teruji, unduh lisensi instan, dan integrasikan modul ke sistem Anda.'
              : 'Publikasikan blueprint Anda, tetapkan harga lisensi, dan dapatkan royalti dari developer global.',
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleTab({
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
