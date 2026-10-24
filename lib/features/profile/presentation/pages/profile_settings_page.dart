import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/profile_settings_provider.dart';
import '../widgets/profile_settings_form.dart';
import '../widgets/profile_settings_sidebar.dart';

/// AI-Era Revamped Profile & Settings Page utilizing clean decoupled widgets.
class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  final TextEditingController _firstNameController = TextEditingController(text: 'SB');
  final TextEditingController _lastNameController = TextEditingController(text: 'USER4');
  final TextEditingController _emailController = TextEditingController(text: 'sbuser4@gstsof.com');
  final TextEditingController _mobileController = TextEditingController(text: '9477317208');
  final TextEditingController _dobController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'title': StringManager.accountSettingsTab, 'subtitle': StringManager.accountSettingsSubtitle, 'icon': Icons.person_outline_rounded},
    {'title': StringManager.companySettingsTab, 'subtitle': StringManager.companySettingsSubtitle, 'icon': Icons.business_rounded},
    {'title': StringManager.invoiceSettingsTab, 'subtitle': StringManager.invoiceSettingsSubtitle, 'icon': Icons.description_outlined},
    {'title': StringManager.irnEwbGstinTab, 'subtitle': StringManager.irnEwbGstinSubtitle, 'icon': Icons.qr_code_rounded},
    {'title': StringManager.invoiceTemplatesTab, 'subtitle': StringManager.invoiceTemplatesSubtitle, 'icon': Icons.article_outlined},
    {'title': StringManager.planBillingTab, 'subtitle': StringManager.planBillingSubtitle, 'icon': Icons.credit_card_rounded},
    {'title': StringManager.apiCallHistoryTab, 'subtitle': StringManager.apiCallHistorySubtitle, 'icon': Icons.history_rounded},
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _onSave() {
    GlobalLoader.show(context, message: 'Saving profile updates...');
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      GlobalLoader.hide(context);
      context.showSnackBar('Profile information updated successfully!');
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(profileSettingsNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          StringManager.settingsTitle,
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
                      selectedIndex: settingsState.selectedCategoryIndex,
                      onSelected: (index) => ref.read(profileSettingsNotifierProvider.notifier).setCategoryIndex(index),
                      isDark: isDark,
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: ProfileSettingsForm(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        mobileController: _mobileController,
                        dobController: _dobController,
                        onSave: _onSave,
                        onCancel: () => context.showSnackBar('Cancelled'),
                        onUploadPhoto: () => context.showSnackBar('Upload photo clicked'),
                        onChangeMobile: () => context.showSnackBar('Change mobile clicked'),
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = settingsState.selectedCategoryIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat['title'] as String),
                            selected: isSelected,
                            onSelected: (val) {
                              ref.read(profileSettingsNotifierProvider.notifier).setCategoryIndex(index);
                            },
                            selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.2),
                            labelStyle: getBoldStyle(
                              fontSize: FontManager.s12,
                              color: isSelected ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ProfileSettingsForm(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        mobileController: _mobileController,
                        dobController: _dobController,
                        onSave: _onSave,
                        onCancel: () => context.showSnackBar('Cancelled'),
                        onUploadPhoto: () => context.showSnackBar('Upload photo clicked'),
                        onChangeMobile: () => context.showSnackBar('Change mobile clicked'),
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
