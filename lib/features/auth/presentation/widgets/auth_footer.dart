import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Reusable Auth Footer widget for switching between Login and Register.
class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooter({
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
