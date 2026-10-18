import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Reusable Support Code Box widget for Profile page.
class ProfileSupportBox extends StatelessWidget {
  const ProfileSupportBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent_rounded, color: ColorManager.primaryGreen),
              const SizedBox(width: 8),
              Text(
                StringManager.profileSupportCode,
                style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.showSnackBar(StringManager.supportCodeCopied),
            child: const Text(StringManager.copyText),
          ),
        ],
      ),
    );
  }
}
