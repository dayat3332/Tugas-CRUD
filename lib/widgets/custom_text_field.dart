import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? badge;
  final Color? badgeColor;
  final String hintText;
  final IconData? prefixIcon;
  final String? prefixSvg;
  final bool isPassword;
  final TextEditingController? controller;
  final String? initialValue;

  const CustomTextField({
    super.key,
    required this.label,
    this.badge,
    this.badgeColor,
    required this.hintText,
    this.prefixIcon,
    this.prefixSvg,
    this.isPassword = false,
    this.controller,
    this.initialValue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.badge != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  widget.badge!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: widget.badgeColor ?? AppColors.green,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Input field
        TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixSvg != null
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: AppSvgIcon(
                      assetName: widget.prefixSvg!,
                      width: 18,
                      height: 18,
                      color: AppColors.textTertiary,
                    ),
                  )
                : (widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: AppColors.textTertiary,
                        size: 20,
                      )
                    : null),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
