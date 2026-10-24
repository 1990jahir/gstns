import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/profile_settings_provider.dart';
import '../widgets/company_settings_form.dart';
import '../widgets/profile_settings_sidebar.dart';

/// Professional Company Settings Page mirroring the web company settings dashboard.
class CompanySettingsPage extends ConsumerStatefulWidget {
  const CompanySettingsPage({super.key});

  @override
  ConsumerState<CompanySettingsPage> createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends ConsumerState<CompanySettingsPage> {
  final List<Map<String, dynamic>> _categories = [
    {'title': StringManager.accountSettingsTab, 'subtitle': StringManager.accountSettingsSubtitle, 'icon': Icons.person_outline_rounded},
    {'title': StringManager.companySettingsTab, 'subtitle': StringManager.companySettingsSubtitle, 'icon': Icons.business_rounded},
    {'title': StringManager.invoiceSettingsTab, 'subtitle': StringManager.invoiceSettingsSubtitle, 'icon': Icons.description_outlined},
    {'title': StringManager.irnEwbGstinTab, 'subtitle': StringManager.irnEwbGstinSubtitle, 'icon': Icons.qr_code_rounded},
    {'title': StringManager.invoiceTemplatesTab, 'subtitle': StringManager.invoiceTemplatesSubtitle, 'icon': Icons.article_outlined},
    {'title': StringManager.planBillingTab, 'subtitle': StringManager.planBillingSubtitle, 'icon': Icons.credit_card_rounded},
    {'title': StringManager.apiCallHistoryTab, 'subtitle': StringManager.apiCallHistorySubtitle, 'icon': Icons.history_rounded},
  ];

  void _onSave() {
    GlobalLoader.show(context, message: 'Saving company settings...');
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      GlobalLoader.hide(context);
      context.showSnackBar('Company information updated successfully!');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          StringManager.companySettingsTitle,
          style: getBoldStyle(
            fontSize: FontManager.s20,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ProfileSettingsSidebar(
                      categories: _categories,
                      selectedIndex: 1, // Company Settings is index 1
                      onSelected: (index) {
                        ref.read(profileSettingsNotifierProvider.notifier).setCategoryIndex(index);
                        if (index == 0) {
                          context.pop(); // Go back to profile settings page
                        }
                      },
                      isDark: isDark,
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: CompanySettingsForm(
                        onSave: _onSave,
                        onCancel: () => context.pop(),
                        onUploadLogo: () => context.showSnackBar('Upload company logo clicked'),
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: CompanySettingsForm(
                  onSave: _onSave,
                  onCancel: () => context.pop(),
                  onUploadLogo: () => context.showSnackBar('Upload company logo clicked'),
                  isDark: isDark,
                ),
              ),
      ),
    );
  }
}
