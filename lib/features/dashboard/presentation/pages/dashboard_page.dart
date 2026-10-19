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
import '../widgets/flow_chart_card.dart';
import '../widgets/income_expense_card.dart';
import '../widgets/metric_card_with_chart.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_list.dart';

/// Highly recommended modern UI Dashboard Page with gradient SliverAppBar, trend sparkline metric cards, and financial overview.
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
      body: RefreshIndicator(
        color: ColorManager.primaryGreen,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          context.showSnackBar('Dashboard refreshed successfully');
        },
        child: CustomScrollView(
          slivers: [
            // Modern Gradient SliverAppBar with Collapsing Greeting & Quick Actions
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: ColorManager.primaryGreen,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF047857), Color(0xFF059669), Color(0xFF10B981)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  StringManager.welcomeUser,
                                  style: getBoldStyle(fontSize: FontManager.s22, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Text('👋', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    StringManager.supportPhone,
                                    style: getMediumStyle(fontSize: FontManager.s12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          StringManager.welcomeSubtitle,
                          style: getRegularStyle(fontSize: FontManager.s13, color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(height: 12),
                        // Quick Status pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, size: 14, color: Colors.lightGreenAccent),
                              const SizedBox(width: 6),
                              Text('GSTIN: 05AAACG2115R1ZN', style: getMediumStyle(fontSize: FontManager.s12, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, color: Colors.white),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                          child: const Text('0', style: TextStyle(fontSize: 8, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 4.0),
                  child: GestureDetector(
                    onTap: () => context.push(AppRouter.profile),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Text('SB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorManager.primaryGreen)),
                    ),
                  ),
                ),
              ],
            ),

            // Dashboard Content Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Bottom padding for floating navbar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Range Selector Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? ColorManager.darkCard : ColorManager.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.calendar_today_outlined, size: 18, color: ColorManager.primaryGreen),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Financial Period',
                                style: getMediumStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dashboardState.selectedDateRange,
                              isDense: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: ColorManager.primaryGreen),
                              items: _dateRanges
                                  .map((range) => DropdownMenuItem(
                                        value: range,
                                        child: Text(range, style: getBoldStyle(fontSize: FontManager.s13, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  ref.read(dashboardNotifierProvider.notifier).setDateRange(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Modern GridView for Metric Cards with Trend Sparklines
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      children: const [
                        MetricCardWithChart(
                          title: StringManager.totalTaxInvoices,
                          amount: '₹ 0.00',
                          percentage: '0%',
                          countLabel: StringManager.invoicesCount,
                          icon: Icons.description_outlined,
                          accentColor: ColorManager.primaryGreen,
                          iconBackgroundColor: Color(0xFFE8F5E9),
                        ),
                        MetricCardWithChart(
                          title: StringManager.totalEWayBills,
                          amount: '₹ 0.00',
                          percentage: '0%',
                          countLabel: StringManager.billsCount,
                          icon: Icons.local_shipping_outlined,
                          accentColor: Colors.blue,
                          iconBackgroundColor: Color(0xFFE3F2FD),
                        ),
                        MetricCardWithChart(
                          title: StringManager.totalPurchaseInvoices,
                          amount: '₹ 0.00',
                          percentage: '0%',
                          countLabel: StringManager.invoicesCount,
                          icon: Icons.shopping_bag_outlined,
                          accentColor: Colors.orange,
                          iconBackgroundColor: Color(0xFFFFF3E0),
                        ),
                        MetricCardWithChart(
                          title: StringManager.totalCreditNotes,
                          amount: '₹ 0.00',
                          percentage: '0%',
                          countLabel: StringManager.notesCount,
                          icon: Icons.edit_note_rounded,
                          accentColor: Colors.purple,
                          iconBackgroundColor: Color(0xFFF3E5F5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sale, Purchase & Credit Note Flow Card
                    FlowChartCard(selectedFilter: dashboardState.selectedGraphFilter),
                    const SizedBox(height: 24),

                    // Quick Actions & Income vs Expense
                    const QuickActionsCard(),
                    const SizedBox(height: 24),
                    const IncomeExpenseCard(),
                    const SizedBox(height: 24),

                    // Recent Activity
                    const RecentActivityList(),
                    const SizedBox(height: 32),

                    // Footer Copyright
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
