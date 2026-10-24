import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../providers/dashboard_provider.dart';

/// Functional Client-Choice Income vs Expense Card with interactive period dropdown
class IncomeExpenseSummaryCard extends ConsumerWidget {
  final bool isDark;

  const IncomeExpenseSummaryCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final data = dashboardState.incomeExpenseData;

    final periodOptions = [
      'This Month',
      'Last Month',
      'This Quarter',
      'This Financial Year',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Functional Dropdown Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income vs Expense',
                style: getBoldStyle(
                  fontSize: FontManager.s16,
                  color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (period) {
                  ref.read(dashboardNotifierProvider.notifier).setIncomeExpensePeriod(period);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: isDark ? ColorManager.darkCard : Colors.white,
                elevation: 6,
                offset: const Offset(0, 32),
                itemBuilder: (context) => periodOptions.map((period) {
                  final isSelected = period == dashboardState.selectedIncomeExpensePeriod;
                  return PopupMenuItem<String>(
                    value: period,
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_rounded, color: ColorManager.primaryGreen, size: 16)
                        else
                          const SizedBox(width: 16),
                        const SizedBox(width: 6),
                        Text(
                          period,
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
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? ColorManager.darkBorder : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dashboardState.selectedIncomeExpensePeriod,
                        style: getMediumStyle(
                          fontSize: FontManager.s12,
                          color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Big Profit Margin Stat
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  data.profitMargin,
                  key: ValueKey(data.profitMargin),
                  style: getBoldStyle(
                    fontSize: 32,
                    color: ColorManager.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Profit Margin',
                style: getMediumStyle(
                  fontSize: FontManager.s14,
                  color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Two columns: Total Income vs Total Expense
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Income Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: ColorManager.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Total Income',
                          style: getRegularStyle(
                            fontSize: FontManager.s12,
                            color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        data.totalIncome,
                        key: ValueKey(data.totalIncome),
                        style: getBoldStyle(
                          fontSize: FontManager.s16,
                          color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      width: 100 * data.incomeRatio,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Total Expense Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA580C),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Total Expense',
                          style: getRegularStyle(
                            fontSize: FontManager.s12,
                            color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        data.totalExpense,
                        key: ValueKey(data.totalExpense),
                        style: getBoldStyle(
                          fontSize: FontManager.s16,
                          color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      width: 100 * data.expenseRatio,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEA580C),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
