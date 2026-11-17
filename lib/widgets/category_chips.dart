import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

class CategoryChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<_ChipData> _chips = [
    _ChipData(label: 'All Stacks', icon: Icons.auto_awesome),
    _ChipData(
        label: 'Next.js', svgAsset: AppAssets.nextjs, icon: Icons.north_east),
    _ChipData(
        label: 'React',
        svgAsset: AppAssets.react,
        icon: Icons.settings_ethernet),
    _ChipData(
        label: 'Laravel',
        svgAsset: AppAssets.laravel,
        icon: Icons.layers_outlined),
    _ChipData(label: 'Flutter', icon: Icons.flutter_dash),
    _ChipData(label: 'FastAPI', svgAsset: AppAssets.python, icon: Icons.bolt),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: _chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _chips[index];
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chip.svgAsset != null)
                    AppSvgIcon(
                      assetName: chip.svgAsset!,
                      width: 16,
                      height: 16,
                    )
                  else if (chip.icon != null)
                    Icon(
                      chip.icon,
                      size: 16,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    chip.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChipData {
  final String label;
  final IconData? icon;
  final String? svgAsset;
  const _ChipData({required this.label, this.icon, this.svgAsset});
}
