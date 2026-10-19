import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Professional Sale, Purchase & Credit Note Flow Card with multi-series visualizer, legends, and axis lines.
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
                  'Sale, Purchase & Credit Note Flow',
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
          const SizedBox(height: 16),

          // Professional Financial Legend Pills
          Row(
            children: [
              _buildLegendItem('Sales', const Color(0xFF10B981)),
              const SizedBox(width: 16),
              _buildLegendItem('Purchase', const Color(0xFFF97316)),
              const SizedBox(width: 16),
              _buildLegendItem('Credit Note', const Color(0xFF8B5CF6)),
            ],
          ),
          const SizedBox(height: 20),

          // Professional Financial Chart Visualizer
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Horizontal Grid lines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['₹2.0L', '₹1.5L', '₹1.0L', '₹0.5L', '₹0']
                      .map((val) => Row(
                            children: [
                              Text(val, style: getRegularStyle(fontSize: FontManager.s10, color: ColorManager.grey)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), height: 1),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                // Custom Multi-Series Trend Curves
                Positioned.fill(
                  child: CustomPaint(
                    painter: FinancialFlowChartPainter(isDark: isDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Month axis label row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                  .map((month) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(month, style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: getMediumStyle(fontSize: FontManager.s12, color: ColorManager.grey),
        ),
      ],
    );
  }
}

/// Custom painter for professional multi-series financial flow chart (Sales, Purchase, Credit Note)
class FinancialFlowChartPainter extends CustomPainter {
  final bool isDark;
  FinancialFlowChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paintSales = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintPurchase = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintCredit = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Sales Curve Path
    final pathSales = Path()
      ..moveTo(0, size.height * 0.7)
      ..cubicTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.6, size.width * 0.6, size.height * 0.3)
      ..cubicTo(size.width * 0.8, size.height * 0.4, size.width * 0.9, size.height * 0.2, size.width, size.height * 0.15);

    // Purchase Curve Path
    final pathPurchase = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(size.width * 0.25, size.height * 0.7, size.width * 0.5, size.height * 0.5, size.width * 0.75, size.height * 0.45)
      ..cubicTo(size.width * 0.85, size.height * 0.4, size.width * 0.95, size.height * 0.35, size.width, size.height * 0.3);

    // Credit Note Curve Path
    final pathCredit = Path()
      ..moveTo(0, size.height * 0.95)
      ..cubicTo(size.width * 0.3, size.height * 0.85, size.width * 0.6, size.height * 0.8, size.width, size.height * 0.7);

    canvas.drawPath(pathSales, paintSales);
    canvas.drawPath(pathPurchase, paintPurchase);
    canvas.drawPath(pathCredit, paintCredit);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
