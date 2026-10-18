import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Income vs Expense widget matching the second screenshot.
class IncomeExpenseCard extends StatelessWidget {
  const IncomeExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
                StringManager.incomeVsExpense,
                style: getBoldStyle(
                  fontSize: FontManager.s18,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(StringManager.thisMonth, style: getMediumStyle(fontSize: FontManager.s12, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildItem(title: StringManager.totalIncome, amount: '₹ 0.00', dotColor: Colors.green, isDark: isDark),
          const SizedBox(height: 16),
          _buildItem(title: StringManager.totalExpense, amount: '₹ 0.00', dotColor: Colors.red, isDark: isDark),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorManager.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pie_chart_outline_rounded, color: ColorManager.primaryGreen, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StringManager.profitMargin, style: getMediumStyle(fontSize: FontManager.s12, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary)),
                    const SizedBox(height: 2),
                    Text('0%', style: getBoldStyle(fontSize: FontManager.s18, color: ColorManager.primaryGreen)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String title, required String amount, required Color dotColor, required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(title, style: getMediumStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
          ],
        ),
        Text(amount, style: getBoldStyle(fontSize: FontManager.s16, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
      ],
    );
  }
}
