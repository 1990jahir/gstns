import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Reusable Profile Detail Field widget.
class ProfileFieldItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileFieldItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontSize: FontManager.s12,
            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? ColorManager.darkCard : ColorManager.lightCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
          ),
          child: Text(
            value,
            style: getRegularStyle(
              fontSize: FontManager.s14,
              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
