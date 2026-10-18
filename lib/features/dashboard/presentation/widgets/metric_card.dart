import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Reusable Metric Card matching the dashboard invoice/bill/note cards.
class MetricCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final String countLabel;
  final IconData icon;
  final Color borderColor;
  final Color iconBackgroundColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.countLabel,
    required this.icon,
    required this.borderColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          top: BorderSide(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
          right: BorderSide(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
          bottom: BorderSide(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
        ),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: borderColor, size: 20),
              ),
              Text(
                title,
                style: getMediumStyle(
                  fontSize: FontManager.s12,
                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: getBoldStyle(
              fontSize: FontManager.s20,
              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$percentage vs last month',
                    style: getRegularStyle(fontSize: FontManager.s12, color: Colors.green),
                  ),
                ],
              ),
              Text(
                countLabel,
                style: getMediumStyle(
                  fontSize: FontManager.s12,
                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
