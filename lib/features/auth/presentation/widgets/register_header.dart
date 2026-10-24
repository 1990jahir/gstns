import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Executive Register Header with glowing logo aura and title.
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.3),
                    const Color(0xFFF97316).withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/png_images/logo_icon.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          StringManager.createYourAccount,
          style: getBoldStyle(
            fontSize: FontManager.s24,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          StringManager.registerSubtitle,
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
