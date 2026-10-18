import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Reusable Step Indicator widget for multi-step registration (Business & Personal Info).
class StepIndicator extends StatelessWidget {
  final int currentStep; // 0 for Business Info, 1 for Personal Info

  const StepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Step 1: Business Info
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorManager.primaryGreen, width: 2),
                color: ColorManager.primaryGreen.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.business_rounded, color: ColorManager.primaryGreen, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              StringManager.businessInfo,
              style: getMediumStyle(
                fontSize: FontManager.s14,
                color: ColorManager.primaryGreen,
              ),
            ),
          ],
        ),
        // Connecting Bar
        Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: currentStep >= 1 ? ColorManager.primaryGreen : (isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Step 2: Personal Info
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: currentStep >= 1 ? ColorManager.primaryGreen : (isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
                  width: 2,
                ),
                color: currentStep >= 1 ? ColorManager.primaryGreen.withValues(alpha: 0.1) : Colors.transparent,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: currentStep >= 1 ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              StringManager.personalInfo,
              style: getMediumStyle(
                fontSize: FontManager.s14,
                color: currentStep >= 1 ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
