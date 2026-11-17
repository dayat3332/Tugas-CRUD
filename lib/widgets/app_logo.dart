import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  final double iconSize;
  final bool showSubtitle;
  final String? subtitle;

  const AppLogo({
    super.key,
    this.fontSize = 18,
    this.iconSize = 28,
    this.showSubtitle = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App logo
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            AppAssets.logo,
            width: iconSize + 8,
            height: iconSize + 8,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: iconSize + 8,
              height: iconSize + 8,
              decoration: BoxDecoration(
                color: const Color(0x1A2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '</>',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: iconSize * 0.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CodeNecromancer',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            if (showSubtitle && subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
