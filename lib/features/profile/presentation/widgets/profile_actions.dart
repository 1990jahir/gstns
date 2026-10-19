import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';

/// Modern Profile Actions widget (Change Password & Logout).
class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => context.showSnackBar(StringManager.changePasswordTriggered),
          icon: const Icon(Icons.lock_reset_rounded, color: ColorManager.primaryGreen),
          label: Text(
            StringManager.changePasswordText,
            style: getMediumStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: ColorManager.primaryGreen),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: isDark ? ColorManager.darkCard : ColorManager.white,
          ),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: StringManager.logoutText,
          icon: Icons.logout_rounded,
          onPressed: () {
            context.go(AppRouter.login);
            context.showSnackBar(StringManager.loggedOutSuccessfully);
          },
        ),
      ],
    );
  }
}
