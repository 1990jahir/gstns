import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_drawer.dart';
import '../widgets/income_expense_card.dart';
import '../widgets/metric_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_list.dart';

/// Mobile-friendly Dashboard Page replicating the web dashboard design with proper theming,
/// pull-to-refresh, profile page navigation, and state management.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  final List<String> _dateRanges = const [
    StringManager.selectRange,
    StringManager.customRange,
    '01 Mar 2027 - 31 Mar 2027',
    '01 Feb 2027 - 28 Feb 2027',
    '01 Jan 2027 - 31 Jan 2027',
    '01 Dec 2026 - 31 Dec 2026',
    '01 Nov 2026 - 30 Nov 2026',
    '01 Oct 2026 - 31 Oct 2026',
    '01 Sep 2026 - 30 Sep 2026',
    '01 Aug 2026 - 31 Aug 2026',
    '01 Jul 2026 - 31 Jul 2026',
    '01 Jun 2026 - 30 Jun 2026',
    '01 May 2026 - 31 May 2026',
    '01 Apr 2026 - 30 Apr 2026',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: DashboardDrawer(
        activeMenu: dashboardState.activeMenu,
        onMenuSelected: (menu) {
          ref.read(dashboardNotifierProvider.notifier).setActiveMenu(menu);
          context.showSnackBar('Navigated to $menu');
        },
      ),
      appBar: AppBar(
        backgroundColor: isDark ? ColorManager.darkSurface : ColorManager.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
        title: Row(
          children: [
            Text(
              StringManager.dashboardTitle,
              style: getBoldStyle(
                fontSize: FontManager.s18,
                color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    StringManager.supportPhone,
                    style: getMediumStyle(fontSize: FontManager.s12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Text('0', style: TextStyle(fontSize: 8, color: Colors.white)),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () => context.push(AppRouter.profile),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: ColorManager.primaryGreen.withValues(alpha: 0.2),
                child: Text('SB', style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.primaryGreen)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: ColorManager.primaryGreen,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            context.showSnackBar('Dashboard refreshed successfully');
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final welcomeBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            StringManager.welcomeUser,
                            style: getBoldStyle(
                              fontSize: FontManager.s24,
                              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('👋', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        StringManager.welcomeSubtitle,
                        style: getRegularStyle(
                          fontSize: FontManager.s14,
                          color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                        ),
                      ),
                    ],
                  );

                  final rangePicker = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? ColorManager.darkCard : ColorManager.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.5)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dashboardState.selectedDateRange,
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryGreen),
                        items: _dateRanges
                            .map((range) => DropdownMenuItem(
                                  value: range,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 16, color: ColorManager.primaryGreen),
                                      const SizedBox(width: 8),
                                      Text(range, style: getMediumStyle(fontSize: FontManager.s13, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(dashboardNotifierProvider.notifier).setDateRange(val);
                          }
                        },
                      ),
                    ),
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [welcomeBlock, rangePicker],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      welcomeBlock,
                      const SizedBox(height: 16),
                      rangePicker,
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.1,
                children: const [
                  MetricCard(
                    title: StringManager.totalTaxInvoices,
                    amount: '₹ 0.00',
                    percentage: '0%',
                    countLabel: StringManager.invoicesCount,
                    icon: Icons.description_outlined,
                    borderColor: ColorManager.primaryGreen,
                    iconBackgroundColor: Color(0xFFE8F5E9),
                  ),
                  MetricCard(
                    title: StringManager.totalEWayBills,
                    amount: '₹ 0.00',
                    percentage: '0%',
                    countLabel: StringManager.billsCount,
                    icon: Icons.local_shipping_outlined,
                    borderColor: Colors.blue,
                    iconBackgroundColor: Color(0xFFE3F2FD),
                  ),
                  MetricCard(
                    title: StringManager.totalPurchaseInvoices,
                    amount: '₹ 0.00',
                    percentage: '0%',
                    countLabel: StringManager.invoicesCount,
                    icon: Icons.shopping_bag_outlined,
                    borderColor: Colors.orange,
                    iconBackgroundColor: Color(0xFFFFF3E0),
                  ),
                  MetricCard(
                    title: StringManager.totalCreditNotes,
                    amount: '₹ 0.00',
                    percentage: '0%',
                    countLabel: StringManager.notesCount,
                    icon: Icons.edit_note_rounded,
                    borderColor: Colors.purple,
                    iconBackgroundColor: Color(0xFFF3E5F5),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? ColorManager.darkCard : ColorManager.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringManager.flowTitle,
                          style: getBoldStyle(
                            fontSize: FontManager.s16,
                            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(dashboardState.selectedGraphFilter, style: getMediumStyle(fontSize: FontManager.s12, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 180,
                      child: Center(
                        child: Text(
                          StringManager.graphFlowVisualizer,
                          textAlign: TextAlign.center,
                          style: getRegularStyle(
                            fontSize: FontManager.s13,
                            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const QuickActionsCard(),
              const SizedBox(height: 24),
              const IncomeExpenseCard(),
              const SizedBox(height: 24),

              const RecentActivityList(),
              const SizedBox(height: 32),

              Center(
                child: Text(
                  StringManager.footerCopyright,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontSize: FontManager.s12,
                    color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
