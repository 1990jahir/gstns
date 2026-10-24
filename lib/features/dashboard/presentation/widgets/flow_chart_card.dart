import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/dashboard_provider.dart';

/// Functional Client-Choice Flow Card with interactive period filters and dynamic metrics
class FlowChartCard extends ConsumerStatefulWidget {
  final String selectedFilter;

  const FlowChartCard({super.key, required this.selectedFilter});

  @override
  ConsumerState<FlowChartCard> createState() => _FlowChartCardState();
}

class _FlowChartCardState extends ConsumerState<FlowChartCard> {
  final Set<String> _selectedSeries = {'Sale', 'Purchase', 'Credit Note'};

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final detail = dashboardState.flowDetail;
    final months = dashboardState.flowMonths;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title, Subtitle, Refresh & More
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sale, Purchase & Credit Note Flow',
                      style: getBoldStyle(
                        fontSize: FontManager.s15,
                        color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap a point or period to see figures',
                      style: getRegularStyle(
                        fontSize: FontManager.s12,
                        color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(dashboardNotifierProvider.notifier).setFlowRange(dashboardState.selectedFlowRange);
                      context.showSnackBar('Refreshed financial flow data');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: isDark ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    onSelected: (val) => context.showSnackBar('$val selected'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: isDark ? ColorManager.darkCard : Colors.white,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Export CSV', child: Text('Export as CSV', style: TextStyle(fontSize: 12))),
                      const PopupMenuItem(value: 'Export PDF', child: Text('Export as PDF', style: TextStyle(fontSize: 12))),
                      const PopupMenuItem(value: 'Detailed Analysis', child: Text('View Details', style: TextStyle(fontSize: 12))),
                    ],
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Period Filter Pills (12M, 6M, 3M, 7D)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: ['12M', '6M', '3M', '7D'].map((range) {
                final isSelected = dashboardState.selectedFlowRange == range;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(dashboardNotifierProvider.notifier).setFlowRange(range);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? ColorManager.darkSurface : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        range,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Legend Chips (Sale, Purchase, Credit Note, Debit Note)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildLegendChip('Sale', const Color(0xFF16A34A)),
                const SizedBox(width: 8),
                _buildLegendChip('Purchase', const Color(0xFFEA580C)),
                const SizedBox(width: 8),
                _buildLegendChip('Credit Note', const Color(0xFF0284C7)),
                const SizedBox(width: 8),
                _buildLegendChip('Debit Note', const Color(0xFF94A3B8)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Line Chart Visualizer with Y & X axis labels
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-Axis labels
                SizedBox(
                  width: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹50L', style: getRegularStyle(fontSize: 10, color: const Color(0xFF94A3B8))),
                      Text('₹25L', style: getRegularStyle(fontSize: 10, color: const Color(0xFF94A3B8))),
                      Text('₹0', style: getRegularStyle(fontSize: 10, color: const Color(0xFF94A3B8))),
                    ],
                  ),
                ),
                // Chart Area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _MultiLineChartPainter(
                            isDark: isDark,
                            showSale: _selectedSeries.contains('Sale'),
                            showPurchase: _selectedSeries.contains('Purchase'),
                            showCredit: _selectedSeries.contains('Credit Note'),
                            salePoints: dashboardState.flowSalePoints,
                            purchasePoints: dashboardState.flowPurchasePoints,
                            creditPoints: dashboardState.flowCreditPoints,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // X-Axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: months.map((month) {
                          final isLast = month == months.last;
                          return Text(
                            month,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                              color: isLast
                                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                  : const Color(0xFF94A3B8),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detail Box for Selected Period
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF132A1C) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF166534) : const Color(0xFFDCFCE7),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        detail.periodLabel,
                        key: ValueKey(detail.periodLabel),
                        style: getBoldStyle(
                          fontSize: FontManager.s14,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up, size: 12, color: Color(0xFF16A34A)),
                          const SizedBox(width: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              detail.profitBadge,
                              key: ValueKey(detail.profitBadge),
                              style: getBoldStyle(
                                fontSize: FontManager.s11,
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('Sale', style: getRegularStyle(fontSize: 11, color: const Color(0xFF64748B))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              detail.saleAmount,
                              key: ValueKey(detail.saleAmount),
                              style: getBoldStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFEA580C), shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('Purchase', style: getRegularStyle(fontSize: 11, color: const Color(0xFF64748B))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              detail.purchaseAmount,
                              key: ValueKey(detail.purchaseAmount),
                              style: getBoldStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF0284C7), shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('Credit Note', style: getRegularStyle(fontSize: 11, color: const Color(0xFF64748B))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              detail.creditNoteAmount,
                              key: ValueKey(detail.creditNoteAmount),
                              style: getBoldStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gross Profit', style: getRegularStyle(fontSize: 11, color: const Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              detail.grossProfitAmount,
                              key: ValueKey(detail.grossProfitAmount),
                              style: getBoldStyle(fontSize: 13, color: const Color(0xFF16A34A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendChip(String label, Color color) {
    final isSelected = _selectedSeries.contains(label);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            if (_selectedSeries.length > 1) _selectedSeries.remove(label);
          } else {
            _selectedSeries.add(label);
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.08))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiLineChartPainter extends CustomPainter {
  final bool isDark;
  final bool showSale;
  final bool showPurchase;
  final bool showCredit;
  final List<double> salePoints;
  final List<double> purchasePoints;
  final List<double> creditPoints;

  _MultiLineChartPainter({
    required this.isDark,
    required this.showSale,
    required this.showPurchase,
    required this.showCredit,
    required this.salePoints,
    required this.purchasePoints,
    required this.creditPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw 3 horizontal grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white12 : const Color(0xFFF1F5F9))
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), gridPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), gridPaint);

    if (showSale && salePoints.isNotEmpty) {
      _drawSmoothCurve(canvas, size, salePoints, const Color(0xFF16A34A));
    }
    if (showPurchase && purchasePoints.isNotEmpty) {
      _drawSmoothCurve(canvas, size, purchasePoints, const Color(0xFFEA580C));
    }
    if (showCredit && creditPoints.isNotEmpty) {
      _drawSmoothCurve(canvas, size, creditPoints, const Color(0xFF0284C7));
    }

    // Highlight vertical line and dots on last point
    final lastX = size.width;
    final vertLinePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(lastX, 0), Offset(lastX, size.height), vertLinePaint);

    // Highlight points on last point
    if (showSale && salePoints.isNotEmpty) {
      _drawHighlightDot(canvas, Offset(lastX, size.height - (salePoints.last * size.height)), const Color(0xFF16A34A));
    }
    if (showPurchase && purchasePoints.isNotEmpty) {
      _drawHighlightDot(canvas, Offset(lastX, size.height - (purchasePoints.last * size.height)), const Color(0xFFEA580C));
    }
    if (showCredit && creditPoints.isNotEmpty) {
      _drawHighlightDot(canvas, Offset(lastX, size.height - (creditPoints.last * size.height)), const Color(0xFF0284C7));
    }
  }

  void _drawSmoothCurve(Canvas canvas, Size size, List<double> points, Color color) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
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

  void _drawHighlightDot(Canvas canvas, Offset offset, Color color) {
    final fillPaint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(offset, 5.5, fillPaint);
    canvas.drawCircle(offset, 5.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _MultiLineChartPainter oldDelegate) => true;
}
