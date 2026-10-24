import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';

/// Clean decoupled Sidebar widget for Profile Settings categories.
class ProfileSettingsSidebar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isDark;

  const ProfileSettingsSidebar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? ColorManager.darkCard : Colors.white,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedIndex == index;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? ColorManager.primaryGreen.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                cat['icon'] as IconData,
                color: isSelected ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
              ),
              title: Text(
                cat['title'] as String,
                style: getBoldStyle(
                  fontSize: FontManager.s14,
                  color: isSelected ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
                ),
              ),
              subtitle: Text(
                cat['subtitle'] as String,
                style: getRegularStyle(
                  fontSize: FontManager.s11,
                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                ),
              ),
              onTap: () {
                onSelected(index);
                if (index == 1) {
                  context.push(AppRouter.companySettings);
                } else if (index == 2) {
                  context.push(AppRouter.invoiceSettings);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
