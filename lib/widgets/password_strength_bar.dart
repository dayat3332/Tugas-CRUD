import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum PasswordStrength { none, weak, fair, good, strong }

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  final int? percentageOverride;
  final PasswordStrength strength;
  final int entropy;

  const PasswordStrengthBar({
    super.key,
    this.password = '',
    this.percentageOverride,
    this.strength = PasswordStrength.strong,
    this.entropy = 98,
  });

  int get percentage {
    if (percentageOverride != null) {
      return percentageOverride!;
    }
    if (password.isEmpty) {
      return 0;
    }
    // Kriteria kuat (100%): minimal 8 karakter, serta memiliki kombinasi huruf dan (angka atau simbol)
    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    final hasDigitOrSpecial =
        password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));
    if (password.length >= 8 && hasLetter && hasDigitOrSpecial) {
      return 100;
    }
    return 50;
  }

  int get _filledSegments {
    if (percentage >= 100) return 4;
    if (percentage >= 50) return 2;
    return 0;
  }

  Color get _color {
    if (percentage >= 100) {
      return const Color(0xFF10B981); // Hijau / Kuat (Bagus 100%)
    }
    if (percentage >= 50) {
      return const Color(0xFFF59E0B); // Kuning / Rendah (50%)
    }
    return const Color(0xFF94A3B8); // Abu-abu / Mulai dari 0%
  }

  String get _label {
    if (percentage >= 100) {
      return 'Kuat (100%)';
    }
    if (percentage >= 50) {
      return 'Rendah (50%)';
    }
    return '0%';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // 4 segmented bars
        Row(
          children: List.generate(4, (index) {
            final isFilled = index < _filledSegments;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 4.5,
                margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isFilled ? _color : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Info row: Shield icon + Kekuatan Sandi: [Label] ... 8+ karakter, symbol & angka
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: _color,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Kekuatan Sandi: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _color,
                  ),
                ),
              ],
            ),
            const Flexible(
              child: Text(
                '8+ karakter, symbol & angka',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
