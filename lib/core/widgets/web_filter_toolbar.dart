import 'package:flutter/material.dart';
import '../res/color_manager.dart';
import '../res/string_manager.dart';

/// Standard web-aligned filter and pagination toolbar matching GSTSOF portal:
/// Row 1: Show [ 50 v ], Start Date, End Date, [ Q green button ]
/// Row 2: Search By [ dropdown v ], Search [ input Q ]
class WebFilterToolbar extends StatelessWidget {
  final int entriesPerPage;
  final ValueChanged<int?> onEntriesPerPageChanged;
  final String startDate;
  final ValueChanged<String> onStartDateChanged;
  final String endDate;
  final ValueChanged<String> onEndDateChanged;
  final VoidCallback onDateSearchPressed;
  final String searchBy;
  final List<String> searchByOptions;
  final ValueChanged<String?> onSearchByChanged;
  final String searchQuery;
  final ValueChanged<String> onSearchQueryChanged;
  final String searchHint;

  const WebFilterToolbar({
    super.key,
    required this.entriesPerPage,
    required this.onEntriesPerPageChanged,
    required this.startDate,
    required this.onStartDateChanged,
    required this.endDate,
    required this.onEndDateChanged,
    required this.onDateSearchPressed,
    required this.searchBy,
    required this.searchByOptions,
    required this.onSearchByChanged,
    required this.searchQuery,
    required this.onSearchQueryChanged,
    this.searchHint = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        onChanged: onEntriesPerPageChanged,
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
                      onChanged: onStartDateChanged,
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
                      onChanged: onEndDateChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Green Search Button [ Q ]
              InkWell(
                onTap: onDateSearchPressed,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Search By [ dropdown v ], Search [ input Q ]
          Row(
            children: [
              // Search By dropdown
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: searchBy,
                    isDense: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                    items: searchByOptions.map((opt) {
                      return DropdownMenuItem(value: opt, child: Text(opt));
                    }).toList(),
                    onChanged: onSearchByChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Search Input with trailing magnifying glass
              Expanded(
                child: Container(
                  height: 40,
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
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: searchHint,
                            hintStyle: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: onSearchQueryChanged,
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
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

