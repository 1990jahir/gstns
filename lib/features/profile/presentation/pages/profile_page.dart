import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_field_tile.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_support_box.dart';

/// Dedicated Profile Page with interactive settings navigation tiles placed below the Support code section.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          StringManager.profileDetailsTitle,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? ColorManager.white : ColorManager.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), // Bottom padding for floating navbar
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileHeaderCard(),
                  const SizedBox(height: 24),
                  ProfileSectionCard(
                    title: 'Personal Information',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.person_outline_rounded,
                        label: StringManager.profileNameLabel,
                        value: StringManager.profileNameValue,
                        color: Colors.blue,
                      ),
                      ProfileFieldTile(
                        icon: Icons.badge_outlined,
                        label: StringManager.profileIdLabel,
                        value: StringManager.profileIdValue,
                        color: Colors.purple,
                      ),
                      ProfileFieldTile(
                        icon: Icons.email_outlined,
                        label: StringManager.profileEmailLabel,
                        value: StringManager.profileEmailValue,
                        color: Colors.teal,
                      ),
                      ProfileFieldTile(
                        icon: Icons.phone_outlined,
                        label: StringManager.profileContactLabel,
                        value: StringManager.profileContactValue,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProfileSectionCard(
                    title: 'Business & Tax Details',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.business_rounded,
                        label: StringManager.profileCompanyLabel,
                        value: StringManager.profileCompanyValue,
                        color: Colors.orange,
                      ),
                      ProfileFieldTile(
                        icon: Icons.receipt_long_outlined,
                        label: StringManager.profileGstinLabel,
                        value: StringManager.profileGstinValue,
                        color: Colors.indigo,
                      ),
                      ProfileFieldTile(
                        icon: Icons.credit_card_rounded,
                        label: StringManager.profilePanLabel,
                        value: StringManager.profilePanValue,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProfileSectionCard(
                    title: 'Financial Overview',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.account_balance_wallet_outlined,
                        label: StringManager.profileWalletLabel,
                        value: StringManager.profileWalletValue,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProfileSupportBox(),
                  const SizedBox(height: 24),

                  // Settings Navigation Section placed BELOW Support code section
                  ProfileSectionCard(
                    title: 'Settings & Configurations',
                    children: [
                      _buildSettingsTile(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: StringManager.accountSettingsTab,
                        subtitle: StringManager.accountSettingsSubtitle,
                        color: Colors.blue,
                        isDark: isDark,
                        onTap: () => context.push(AppRouter.profileSettings),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.business_rounded,
                        title: StringManager.companySettingsTab,
                        subtitle: StringManager.companySettingsSubtitle,
                        color: Colors.orange,
                        isDark: isDark,
                        onTap: () => context.push(AppRouter.companySettings),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.description_outlined,
                        title: StringManager.invoiceSettingsTab,
                        subtitle: StringManager.invoiceSettingsSubtitle,
                        color: Colors.green,
                        isDark: isDark,
                        onTap: () => context.push(AppRouter.invoiceSettings),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.qr_code_rounded,
                        title: StringManager.irnEwbGstinTab,
                        subtitle: StringManager.irnEwbGstinSubtitle,
                        color: Colors.purple,
                        isDark: isDark,
                        onTap: () => context.showSnackBar('Opening IRN, EWB & GSTIN Settings...'),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.article_outlined,
                        title: StringManager.invoiceTemplatesTab,
                        subtitle: StringManager.invoiceTemplatesSubtitle,
                        color: Colors.teal,
                        isDark: isDark,
                        onTap: () => context.showSnackBar('Opening Invoice Templates...'),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.credit_card_rounded,
                        title: StringManager.planBillingTab,
                        subtitle: StringManager.planBillingSubtitle,
                        color: Colors.pink,
                        isDark: isDark,
                        onTap: () => context.showSnackBar('Opening Plan & Billing...'),
                      ),
                      const Divider(height: 1, indent: 48),
                      _buildSettingsTile(
                        context,
                        icon: Icons.history_rounded,
                        title: StringManager.apiCallHistoryTab,
                        subtitle: StringManager.apiCallHistorySubtitle,
                        color: Colors.indigo,
                        isDark: isDark,
                        onTap: () => context.showSnackBar('Opening API Call History...'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProfileActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required bool isDark, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: getBoldStyle(
          fontSize: FontManager.s15,
          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: getRegularStyle(
          fontSize: FontManager.s12,
          color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: ColorManager.grey),
      onTap: onTap,
    );
  }
}
