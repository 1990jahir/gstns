import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/banking_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_category_card.dart';
import '../widgets/expense_filter_bar.dart';
import '../widgets/expense_tab_banner.dart';

/// Modern Manage Expenses Page matching the GSTSOF web portal design:
/// - Screen title: Manage Expenses
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Expense No. v ], Search [ input Q ]
/// - Dual Tab Bar: [ Category ] [ Item ]
/// - Section Banner: Green box icon, "Expense Items" / "Expense Categories", action button: "Choose Item" / "Add Category"
/// - Table list with exact web fields: SL. No, Date, EXP No., Party, Payment, Amount, Due Date, Action
class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(expenseSelectedTabProvider); // 0 = Category, 1 = Item
    final expenseItems = ref.watch(filteredExpensesProvider);
    final expenseCategories = ref.watch(filteredExpenseCategoriesProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.manageExpenses,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          // Blue Refresh Button matching web screenshot
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () => context.showSnackBar('Refreshing expenses from server...'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // Web blue color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: const Icon(Icons.sync_rounded, size: 16, color: Colors.white),
              label: const Text(
                StringManager.refresh,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Filter Toolbar: Show [50], Start Date, End Date, Search By, Search Input
            ExpenseFilterBar(
              onRefresh: () => context.showSnackBar('Applying date & keyword filters...'),
            ),

            // Tab Bar: [ Category ] [ Item ] & Green Box Section Header Banner
            ExpenseTabBanner(
              onActionPressed: () {
                if (selectedTab == 1) {
                  context.push(AppRouter.addExpense);
                } else {
                  context.push(AppRouter.addCategory);
                }
              },
            ),

            // Tab Content: Item List or Category List
            Expanded(
              child: selectedTab == 1
                  ? (expenseItems.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: expenseItems.length,
                          itemBuilder: (context, index) {
                            return ExpenseCard(expense: expenseItems[index]);
                          },
                        ))
                  : (expenseCategories.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: expenseCategories.length,
                          itemBuilder: (context, index) {
                            return ExpenseCategoryCard(category: expenseCategories[index]);
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 12),
          Text(
            StringManager.noRecordFound,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
