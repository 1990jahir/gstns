import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../providers/banking_provider.dart';

/// Presentation widget matching the top search & filter toolbar from GSTSOF web:
/// Show [ 50 v ], Start Date, End Date, [ Q green button ], Search By [ Expense No. v ], Search [ input Q ]
class ExpenseFilterBar extends ConsumerWidget {
  final VoidCallback onRefresh;

  const ExpenseFilterBar({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entriesPerPage = ref.watch(expenseEntriesPerPageProvider);
    final searchBy = ref.watch(expenseSearchByProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Row 1: Show [ 50 v ], Start Date, End Date, [ Green Search Button ]
          Row(
            children: [
              // Show [ 50 v ]
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Text(
                      StringManager.show,
                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: entriesPerPage,
                        isDense: true,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                        items: const [
                          DropdownMenuItem(value: 10, child: Text('10')),
                          DropdownMenuItem(value: 25, child: Text('25')),
                          DropdownMenuItem(value: 50, child: Text('50')),
                          DropdownMenuItem(value: 100, child: Text('100')),
                        ],
                        onChanged: (val) {
                          if (val != null) ref.read(expenseEntriesPerPageProvider.notifier).state = val;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Start Date
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: StringManager.startDate,
                        hintStyle: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) => ref.read(expenseStartDateProvider.notifier).state = v,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // End Date
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: StringManager.endDate,
                        hintStyle: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) => ref.read(expenseEndDateProvider.notifier).state = v,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Green Filter Button
              SizedBox(
                height: 40,
                width: 40,
                child: ElevatedButton(
                  onPressed: onRefresh,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryGreen,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Search By Dropdown + Search input
          Row(
            children: [
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: searchBy,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                    items: const [
                      DropdownMenuItem(value: 'Expense No.', child: Text('Expense No.')),
                      DropdownMenuItem(value: 'Party', child: Text('Party')),
                      DropdownMenuItem(value: 'Category', child: Text('Category')),
                    ],
                    onChanged: (val) {
                      if (val != null) ref.read(expenseSearchByProvider.notifier).state = val;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (v) => ref.read(expenseSearchQueryProvider.notifier).state = v,
                        ),
                      ),
                      const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

