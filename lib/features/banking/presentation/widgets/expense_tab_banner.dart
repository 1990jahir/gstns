import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../providers/banking_provider.dart';

/// Presentation widget rendering the Category & Item Tabs and Green Section Header Banner
/// matching the exact layout in the GSTSOF web portal screenshot.
class ExpenseTabBanner extends ConsumerWidget {
  final VoidCallback onActionPressed;

  const ExpenseTabBanner({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(expenseSelectedTabProvider); // 0 = Category, 1 = Item

    final isItemTab = selectedTab == 1;

    return Column(
      children: [
        // Tab Selector Row: [ Category ] [ Item ]
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              // Category Tab Button
              InkWell(
                onTap: () => ref.read(expenseSelectedTabProvider.notifier).state = 0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedTab == 0
                        ? ColorManager.primaryGreen.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      bottom: BorderSide(
                        color: selectedTab == 0 ? ColorManager.primaryGreen : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 18,
                        color: selectedTab == 0 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        StringManager.categoryTab,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                          color: selectedTab == 0 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Item Tab Button
              InkWell(
                onTap: () => ref.read(expenseSelectedTabProvider.notifier).state = 1,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedTab == 1
                        ? ColorManager.primaryGreen.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      bottom: BorderSide(
                        color: selectedTab == 1 ? ColorManager.primaryGreen : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        size: 18,
                        color: selectedTab == 1 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        StringManager.itemTab,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                          color: selectedTab == 1 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Green Box Section Header Banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isItemTab ? Icons.inventory_2_outlined : Icons.category_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isItemTab ? StringManager.expenseItems : StringManager.expenseCategories,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isItemTab ? StringManager.expenseItemsSubtitle : StringManager.expenseCategoriesSubtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(isItemTab ? Icons.inventory_2_outlined : Icons.add_rounded, color: Colors.white, size: 16),
                label: Text(
                  isItemTab ? StringManager.chooseItem : StringManager.addCategory,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

