import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Reusable Auth Header widget used across Login and Register pages.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Logo Container with soft green glow & shadow
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ColorManager.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/png_images/logo_icon.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.bolt,
                  color: ColorManager.primaryGreen,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontSize: FontManager.s28,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontSize: FontManager.s14,
            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
