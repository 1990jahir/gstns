import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';

/// Redesigned Menu Bottom Sheet inspired by modern fintech app menus (Drivvo-style profile header & grouped card sections).
class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Profile Header Card inside Menu (Drivvo style)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [ColorManager.darkSurface, ColorManager.darkSurface]
                        : [ColorManager.primaryGreen.withValues(alpha: 0.08), ColorManager.primaryGreen.withValues(alpha: 0.02)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: ColorManager.primaryGreen,
                      child: Text('SB', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                StringManager.profileNameValue,
                                style: getBoldStyle(
                                  fontSize: FontManager.s16,
                                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Pro Plan',
                                  style: getBoldStyle(fontSize: FontManager.s10, color: Colors.amber.shade800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GSTIN: 05AAACG2115R1ZN',
                            style: getRegularStyle(
                              fontSize: FontManager.s12,
                              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Scrollable Menu Sections
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildSectionHeader(context, 'GENERAL', isDark),
                    const SizedBox(height: 8),
                    _buildMenuCard(context, icon: Icons.dashboard_rounded, title: StringManager.dashboardTitle, color: Colors.green, isDark: isDark, onTap: () => Navigator.pop(context)),
                    const SizedBox(height: 8),
                    _buildMenuCard(context, icon: Icons.person_rounded, title: 'Profile & Company', color: Colors.cyan, isDark: isDark, onTap: () {
                      Navigator.pop(context);
                      context.push(AppRouter.profile);
                    }),
                    const SizedBox(height: 16),

                    _buildSectionHeader(context, 'MASTERS', isDark),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.folder_rounded, title: StringManager.masters, color: Colors.blue, isDark: isDark, subItems: ['Item Group', 'Item Category', 'Item List', 'Transporters']),
                    const SizedBox(height: 16),

                    _buildSectionHeader(context, 'SALES & INVOICING', isDark),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.sell_rounded, title: StringManager.sales, color: Colors.orange, isDark: isDark, subItems: ['Customers', 'Invoices', 'Credit Notes/Sales Return', 'Delivery Challan']),
                    const SizedBox(height: 16),

                    _buildSectionHeader(context, 'PURCHASE', isDark),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.shopping_cart_rounded, title: StringManager.purchase, color: Colors.purple, isDark: isDark, subItems: ['Vendors', 'Purchase Invoice', 'Incoming Invoice', 'Debit Notes']),
                    const SizedBox(height: 16),

                    _buildSectionHeader(context, 'CASH, BANK & EXPENSES', isDark),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.account_balance_wallet_rounded, title: StringManager.cashAndBank, color: Colors.teal, isDark: isDark, subItems: ['Bank Accounts', 'Transactions']),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.receipt_long_rounded, title: StringManager.expensesAndIncome, color: Colors.indigo, isDark: isDark, subItems: ['Expenses', 'Income']),
                    const SizedBox(height: 16),

                    _buildSectionHeader(context, 'REPORTS', isDark),
                    const SizedBox(height: 8),
                    _buildExpandableGroup(context, icon: Icons.bar_chart_rounded, title: StringManager.reports, color: Colors.pink, isDark: isDark, subItems: ['GSTR-1', 'GSTR-3B', 'Profit & Loss', 'Balance Sheet']),
                    const SizedBox(height: 24),

                    _buildMenuCard(context, icon: Icons.logout_rounded, title: StringManager.logoutText, color: Colors.red, isDark: isDark, onTap: () {
                      Navigator.pop(context);
                      context.go(AppRouter.login);
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: getBoldStyle(
        fontSize: FontManager.s12,
        color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required Color color, required bool isDark, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? ColorManager.darkSurface : ColorManager.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: getBoldStyle(
                  fontSize: FontManager.s15,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: ColorManager.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableGroup(BuildContext context, {required IconData icon, required String title, required Color color, required bool isDark, required List<String> subItems}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkSurface : ColorManager.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
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
          iconColor: color,
          collapsedIconColor: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: subItems
              .map(
                (sub) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.showSnackBar('Selected: $title > $sub');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [ColorManager.darkCard, ColorManager.darkCard.withValues(alpha: 0.9)]
                              : [Colors.white, color.withValues(alpha: 0.04)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.subdirectory_arrow_right_rounded, color: color, size: 16),
                          const SizedBox(width: 10),
                          Text(
                            sub,
                            style: getMediumStyle(
                              fontSize: FontManager.s14,
                              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
