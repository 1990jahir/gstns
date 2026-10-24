import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/styles_manager.dart';

class RegisterHeaderNew extends StatelessWidget {
  final int currentStep; // 1, 2, or 3

  const RegisterHeaderNew({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? ColorManager.authTextDark : ColorManager.authTextLight;
    final mutedColor = isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight;

    String title;
    String subtitle;

    switch (currentStep) {
      case 2:
        title = 'Secure your account';
        subtitle = 'Choose how you’ll sign in.';
        break;
      case 3:
        title = 'Welcome aboard';
        subtitle = 'Your business account is ready.';
        break;
      case 1:
      default:
        title = 'Create your business account';
        subtitle = 'Verify your GSTIN and we’ll fill in the rest.';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 14.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Title
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                title,
                key: ValueKey('title_$currentStep'),
                style: getBoldStyle(
                  fontSize: 23,
                  color: textColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Animated Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                subtitle,
                key: ValueKey('sub_$currentStep'),
                style: getRegularStyle(
                  fontSize: 13.5,
                  color: mutedColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
