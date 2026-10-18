import 'package:flutter/material.dart';
import '../res/color_manager.dart';
import '../res/font_manager.dart';
import '../res/styles_manager.dart';

/// Global reusable Footer Action widget decoupled from any feature.
class CustomFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const CustomFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          text,
          style: getRegularStyle(
            fontSize: FontManager.s14,
            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: getBoldStyle(
              fontSize: FontManager.s14,
              color: ColorManager.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}
