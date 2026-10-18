import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Reusable Profile Header Card widget with gradient background and avatar.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primaryGreen, ColorManager.primaryGreen.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              'SB',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorManager.primaryGreen),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringManager.profileNameValue,
                  style: getBoldStyle(fontSize: FontManager.s20, color: ColorManager.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${StringManager.profileIdLabel}: ${StringManager.profileIdValue}',
                  style: getRegularStyle(fontSize: FontManager.s14, color: ColorManager.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
