import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Modern Widget-style Dashboard Card inspired by Apple Health / Modern UI trend.
class MetricCardWithChart extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final String countLabel;
  final IconData icon;
  final Color accentColor;
  final Color iconBackgroundColor;

  const MetricCardWithChart({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.countLabel,
    required this.icon,
    required this.accentColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Title on left, [...] menu on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: accentColor, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: getBoldStyle(
                      fontSize: FontManager.s14,
                      color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.more_horiz, color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => context.showSnackBar('$title options'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Metric Amount & Percentage Change
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount,
                style: getBoldStyle(
                  fontSize: FontManager.s24,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '+$percentage',
                    style: getBoldStyle(fontSize: FontManager.s12, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'vs last month',
            style: getRegularStyle(
              fontSize: FontManager.s12,
              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Sparkline Chart & Count Badge Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  countLabel,
                  style: getBoldStyle(fontSize: FontManager.s12, color: accentColor),
                ),
              ),
              SizedBox(
                width: 90,
                height: 28,
                child: CustomPaint(
                  painter: SparklinePainter(color: accentColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for mini sparkline trend graph on widget cards
class SparklinePainter extends CustomPainter {
  final Color color;
  SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.4, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
