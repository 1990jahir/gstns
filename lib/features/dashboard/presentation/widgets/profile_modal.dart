import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';

/// Profile Details Modal matching the user's reference screenshots.
class ProfileModal extends StatelessWidget {
  const ProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? ColorManager.darkCard : ColorManager.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Details',
                    style: getBoldStyle(
                      fontSize: FontManager.s18,
                      color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildField(context, label: 'Profile Name', value: 'SB USER4', isDark: isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField(context, label: 'Profile ID', value: 'GT771', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildField(context, label: 'Company Name', value: 'SB USER4', isDark: isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField(context, label: 'GSTIN', value: 'N/A', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildField(context, label: 'Email', value: 'suser4@gstsof.com', isDark: isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField(context, label: 'Contact No', value: '9477317208', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildField(context, label: 'PAN', value: 'CGHP0707E', isDark: isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildField(context, label: 'API Wallet Balance', value: '0', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Support Code & Actions
                    Container(
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
                              Text('Support Code: 783154', style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen)),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.showSnackBar('Support code copied'),
                            child: const Text('Copy'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Change Password & Logout Buttons
                    OutlinedButton.icon(
                      onPressed: () => context.showSnackBar('Change password triggered'),
                      icon: const Icon(Icons.lock_reset_rounded, color: ColorManager.primaryGreen),
                      label: Text('Change Password', style: getMediumStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: ColorManager.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(AppRouter.login);
                        context.showSnackBar('Logged out successfully');
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: Text('Logout', style: getBoldStyle(fontSize: FontManager.s14, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, {required String label, required String value, required bool isDark}) {
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
            color: isDark ? ColorManager.darkSurface : ColorManager.lightCard,
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
