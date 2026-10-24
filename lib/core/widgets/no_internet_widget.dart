import 'package:flutter/material.dart';
import '../res/color_manager.dart';
import '../res/font_manager.dart';
import '../res/styles_manager.dart';
import 'custom_button.dart';

/// Modern professional No Internet Connection Error Widget with retry button.
class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24.0),
      alignment: Alignment.center,
      color: isDark ? ColorManager.darkSurface : const Color(0xFFF7F8FA),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing offline illustration container
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.wifi_off_rounded, size: 42, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontManager.s22,
                color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please check your network connection and try again to proceed with GSTSOF.',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontManager.s14,
                color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: 'Try Again',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
