import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';

/// Modern Report Filter Card widget for date range selection and searching.
class ReportFilterCard extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final VoidCallback onSearch;
  final bool isDark;

  const ReportFilterCard({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.onSearch,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: startDateController,
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: StringManager.startDateLabel,
                labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: endDateController,
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: StringManager.endDateLabel,
                labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorManager.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            ),
            onPressed: onSearch,
            tooltip: StringManager.filterReportTooltip,
          ),
        ],
      ),
    );
  }
}
