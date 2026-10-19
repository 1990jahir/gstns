import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Professional Sale, Purchase & Credit Note Flow Card with gradient border, rich shadows, and chart visualization.
class FlowChartCard extends StatelessWidget {
  final String selectedFilter;

  const FlowChartCard({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [ColorManager.darkCard, ColorManager.darkCard.withValues(alpha: 0.8)]
              : [Colors.white, ColorManager.primaryGreen.withValues(alpha: 0.02)],
        ),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : ColorManager.primaryGreen.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  StringManager.flowTitle,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontSize: FontManager.s18,
                    color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.1),
                  border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedFilter, style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.primaryGreen)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 16, color: ColorManager.primaryGreen),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Months visualization axis placeholder
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
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
                const SizedBox(height: 12),
                // Month axis label row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Jan 2026', 'Feb 2026', 'Mar 2026', 'Apr 2026', 'May 2026', 'Jun 2026', 'Jul 2026', 'Aug 2026', 'Sep 2026', 'Oct 2026', 'Nov 2026', 'Dec 2026']
                        .map((month) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(month, style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
