import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/flow_chart_card.dart';
import '../widgets/income_expense_summary_card.dart';
import '../widgets/overview_metrics_grid.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_list.dart';

/// Client-Choice Revamped Dashboard Page with functional dropdowns and dynamic demo datasets.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;

    final fyOptions = ['FY 2026-27', 'FY 2025-26', 'FY 2024-25'];

    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBackgroundApp : const Color(0xFFF4F6F8),
      body: RefreshIndicator(
        color: ColorManager.primaryGreen,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          if (!context.mounted) return;
          context.showSnackBar('Dashboard refreshed with latest data');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Forest Green Header
              Container(
                color: ColorManager.primaryGreen,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar: Profile Avatar, Company, GSTIN, & Action Icons
                        Row(
                          children: [
                            // AS Avatar
                            GestureDetector(
                              onTap: () => context.push(AppRouter.profile),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: ColorManager.mintAvatarBg,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'AS',
                                  style: getBoldStyle(
                                    fontSize: FontManager.s14,
                                    color: ColorManager.mintAvatarText,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Company Name & GSTIN
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kumar Electricals',
                                    style: getBoldStyle(
                                      fontSize: FontManager.s15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'GSTIN 19ABCDE1234F1Z5',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Top Right Icons: Search, Notifications (with badge 3), Support
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => context.showSnackBar('Search opened'),
                                  icon: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                ),
                                const SizedBox(width: 6),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    IconButton(
                                      onPressed: () => context.showSnackBar('You have 3 notifications'),
                                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(3.5),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text(
                                          '3',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  onPressed: () => context.showSnackBar('Customer support assistant'),
                                  icon: const Icon(Icons.headset_mic_outlined, color: Colors.white, size: 24),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // Welcome Greeting & Functional FY Dropdown
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back, Arpan',
                                    style: getBoldStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Here's what's happening with your business today.",
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Functional FY Dropdown Pill
                            PopupMenuButton<String>(
                              onSelected: (fy) {
                                ref.read(dashboardNotifierProvider.notifier).setFY(fy);
                                context.showSnackBar('Switched to $fy');
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: isDark ? ColorManager.darkCard : Colors.white,
                              elevation: 8,
                              offset: const Offset(0, 36),
                              itemBuilder: (context) => fyOptions.map((fy) {
                                final isSelected = fy == dashboardState.selectedFY;
                                return PopupMenuItem<String>(
                                  value: fy,
                                  child: Row(
                                    children: [
                                      if (isSelected)
                                        const Icon(Icons.check_rounded, color: ColorManager.primaryGreen, size: 16)
                                      else
                                        const SizedBox(width: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        fy,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected
                                              ? ColorManager.primaryGreen
                                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ColorManager.darkForestGreen,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      dashboardState.selectedFY,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Overlapping Content Body
              Transform.translate(
                offset: const Offset(0, -18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Income vs Expense Summary Card
                      IncomeExpenseSummaryCard(isDark: isDark),
                      const SizedBox(height: 20),

                      // Overview Metrics Grid (Tax Invoices, E-Way Bills, Purchase, Credit Notes)
                      OverviewMetricsGrid(isDark: isDark),
                      const SizedBox(height: 20),

                      // Quick Actions & Import Banner
                      const QuickActionsCard(),
                      const SizedBox(height: 20),

                      // Sale, Purchase & Credit Note Flow Card
                      FlowChartCard(selectedFilter: dashboardState.selectedFlowRange),
                      const SizedBox(height: 20),

                      // Recent Activity
                      const RecentActivityList(),
                      const SizedBox(height: 100), // Spacing for floating navbar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
