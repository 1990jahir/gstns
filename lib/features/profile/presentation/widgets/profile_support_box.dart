import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Modern Support Code Box widget for Profile page.
class ProfileSupportBox extends StatelessWidget {
  const ProfileSupportBox({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.support_agent_rounded, color: ColorManager.primaryGreen, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Support PIN', style: getRegularStyle(fontSize: FontManager.s12, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary)),
                  const SizedBox(height: 2),
                  Text(StringManager.profileSupportCode, style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.showSnackBar(StringManager.supportCodeCopied),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(StringManager.copyText, style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
