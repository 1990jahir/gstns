import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../providers/dashboard_provider.dart';

/// Functional Client-Choice Overview Metrics Grid with interactive period dropdown
class OverviewMetricsGrid extends ConsumerWidget {
  final bool isDark;

  const OverviewMetricsGrid({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final metrics = dashboardState.overviewMetrics;

    final periodOptions = [
      'This FY',
      'This Quarter',
      'This Month',
      'Last FY',
    ];

    final taxItem = metrics['tax']!;
    final ewayItem = metrics['eway']!;
    final purchaseItem = metrics['purchase']!;
    final creditItem = metrics['credit']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row: Title & Functional Dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview',
              style: getBoldStyle(
                fontSize: FontManager.s18,
                color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (period) {
                ref.read(dashboardNotifierProvider.notifier).setOverviewPeriod(period);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: isDark ? ColorManager.darkCard : Colors.white,
              elevation: 6,
              offset: const Offset(0, 32),
              itemBuilder: (context) => periodOptions.map((period) {
                final isSelected = period == dashboardState.selectedOverviewPeriod;
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
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dashboardState.selectedOverviewPeriod,
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

        // 2x2 Metric Cards Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: [
            _buildMetricCard(
              title: taxItem.title,
              amount: taxItem.amount,
              subtext: taxItem.count,
              trend: taxItem.trend,
              isPositiveTrend: taxItem.isPositive,
              themeColor: const Color(0xFF16A34A),
              iconBgColor: const Color(0xFFDCFCE7),
              icon: Icons.description_outlined,
              sparklinePoints: taxItem.sparklinePoints,
            ),
            _buildMetricCard(
              title: ewayItem.title,
              amount: ewayItem.amount,
              subtext: ewayItem.count,
              trend: ewayItem.trend,
              isPositiveTrend: ewayItem.isPositive,
              themeColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFFE0F2FE),
              icon: Icons.receipt_long_outlined,
              sparklinePoints: ewayItem.sparklinePoints,
            ),
            _buildMetricCard(
              title: purchaseItem.title,
              amount: purchaseItem.amount,
              subtext: purchaseItem.count,
              trend: purchaseItem.trend,
              isPositiveTrend: purchaseItem.isPositive,
              themeColor: const Color(0xFFEA580C),
              iconBgColor: const Color(0xFFFFEDD5),
              icon: Icons.shopping_bag_outlined,
              sparklinePoints: purchaseItem.sparklinePoints,
            ),
            _buildMetricCard(
              title: creditItem.title,
              amount: creditItem.amount,
              subtext: creditItem.count,
              trend: creditItem.trend,
              isPositiveTrend: creditItem.isPositive,
              themeColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFFF3E8FF),
              icon: Icons.edit_note_rounded,
              sparklinePoints: creditItem.sparklinePoints,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required String subtext,
    required String trend,
    required bool isPositiveTrend,
    required Color themeColor,
    required Color iconBgColor,
    required IconData icon,
    required List<double> sparklinePoints,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark ? themeColor.withValues(alpha: 0.2) : iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: themeColor, size: 20),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            maxLines: 2,
            style: getRegularStyle(
              fontSize: FontManager.s12,
              color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),

          // Big Amount with animated switcher
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              amount,
              key: ValueKey(amount),
              style: getBoldStyle(
                fontSize: FontManager.s18,
                color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Subtext (Count)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              subtext,
              key: ValueKey(subtext),
              style: getRegularStyle(
                fontSize: FontManager.s11,
                color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Trend Row
          Row(
            children: [
              Icon(
                isPositiveTrend ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 14,
                color: isPositiveTrend ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    trend,
                    key: ValueKey(trend),
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontSize: FontManager.s10,
                      color: isPositiveTrend ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Mini Sparkline Graph
          SizedBox(
            height: 24,
            width: double.infinity,
            child: CustomPaint(
              painter: _SparklinePainter(
                points: sparklinePoints,
                lineColor: themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;

  _SparklinePainter({required this.points, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final dx = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final x = i * dx;
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * dx;
        final prevY = size.height - (points[i - 1] * size.height);
        final controlX1 = prevX + (x - prevX) / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + (x - prevX) / 2;
        final controlY2 = y;
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.lineColor != lineColor;
}
