import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                svgAsset: AppAssets.navHome,
                fallbackIcon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                svgAsset: AppAssets.wislit,
                fallbackIcon: Icons.bookmark_border_rounded,
                label: 'Wishlist',
              ),
              _buildNavItem(
                index: 2,
                svgAsset: AppAssets.pustaka,
                fallbackIcon: Icons.menu_book_rounded,
                label: 'Library',
              ),
              _buildNavItem(
                index: 3,
                svgAsset: AppAssets.navProfile,
                fallbackIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String svgAsset,
    required IconData fallbackIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    final itemColor = isSelected ? AppColors.primary : AppColors.textTertiary;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgIcon(
              assetName: svgAsset,
              width: 22,
              height: 22,
              color: itemColor,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
