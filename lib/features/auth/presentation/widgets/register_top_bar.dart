import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';

class RegisterTopBar extends StatelessWidget {
  final int currentStep; // 1, 2, or 3
  final String appName;
  final VoidCallback? onBack;

  const RegisterTopBar({
    super.key,
    required this.currentStep,
    this.appName = StringManager.appTitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? ColorManager.authSurfaceDark : ColorManager.authSurfaceLight;
    final lineColor = isDark ? ColorManager.authLineDark : ColorManager.authLineLight;
    final textColor = isDark ? ColorManager.authTextDark : ColorManager.authTextLight;
    final mutedColor = isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight;

    final showBack = currentStep == 2;
    final stepText = currentStep > 2 ? 'Done' : '$currentStep / 2';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          AnimatedOpacity(
            opacity: showBack ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !showBack,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: lineColor, width: 1.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 22,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Brand Center (Official Logo Mark + App Title)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: lineColor, width: 1.0),
                ),
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  'assets/png_images/logo_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                appName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: textColor,
                  fontFamily: 'Sora',
                ),
              ),
            ],
          ),

          // Step Pill (e.g. "1 / 2", "2 / 2", "Done")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: lineColor, width: 1.0),
            ),
            child: Text(
              stepText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: mutedColor,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
