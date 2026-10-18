import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Navigation Drawer representing the web sidebar menu for mobile-friendly view.
class DashboardDrawer extends StatelessWidget {
  final String activeMenu;
  final ValueChanged<String> onMenuSelected;

  const DashboardDrawer({
    super.key,
    required this.activeMenu,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? ColorManager.darkSurface : ColorManager.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/png_images/logo_icon.png',
                    width: 36,
                    height: 36,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.bolt, color: ColorManager.primaryGreen, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    StringManager.appTitle.replaceAll(' App', ''),
                    style: getBoldStyle(
                      fontSize: FontManager.s20,
                      color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _buildMenuItem(context, icon: Icons.dashboard_outlined, title: StringManager.dashboardTitle, isDark: isDark),
                  _buildExpandableMenuItem(context, icon: Icons.folder_outlined, title: StringManager.masters, isDark: isDark),
                  _buildExpandableMenuItem(context, icon: Icons.sell_outlined, title: StringManager.sales, isDark: isDark),
                  _buildExpandableMenuItem(context, icon: Icons.shopping_cart_outlined, title: StringManager.purchase, isDark: isDark),
                  _buildMenuItem(context, icon: Icons.account_balance_wallet_outlined, title: StringManager.cashAndBank, isDark: isDark),
                  _buildExpandableMenuItem(
                    context,
                    icon: Icons.receipt_long_outlined,
                    title: StringManager.expensesAndIncome,
                    isDark: isDark,
                    subItems: [StringManager.expenses, StringManager.income],
                  ),
                  _buildMenuItem(context, icon: Icons.bar_chart_outlined, title: StringManager.reports, isDark: isDark),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: ColorManager.primaryGreen, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      StringManager.upgradeYourPlan,
                      style: getBoldStyle(
                        fontSize: FontManager.s16,
                        color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      StringManager.unlockPremium,
                      style: getRegularStyle(
                        fontSize: FontManager.s12,
                        color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(StringManager.upgradeNow, style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.white)),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 16, color: ColorManager.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required title, required bool isDark}) {
    final isSelected = activeMenu == title;
    return ListTile(
      leading: Icon(icon, color: isSelected ? ColorManager.primaryGreen : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary)),
      title: Text(
        title,
        style: isSelected
            ? getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen)
            : getMediumStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
      ),
      selected: isSelected,
      selectedTileColor: ColorManager.primaryGreen.withValues(alpha: 0.1),
      onTap: () {
        onMenuSelected(title);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildExpandableMenuItem(BuildContext context, {required IconData icon, required String title, required bool isDark, List<String>? subItems}) {
    return ExpansionTile(
      leading: Icon(icon, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
      title: Text(
        title,
        style: getMediumStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
      ),
      children: subItems
              ?.map((sub) => ListTile(
                    contentPadding: const EdgeInsets.only(left: 56),
                    title: Text(sub, style: getRegularStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary)),
                    onTap: () {
                      onMenuSelected('$title > $sub');
                      Navigator.pop(context);
                    },
                  ))
              .toList() ??
          [],
    );
  }
}
