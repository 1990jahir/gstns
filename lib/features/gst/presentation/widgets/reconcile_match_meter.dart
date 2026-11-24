import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';

/// Presentation widget showing 3-way reconciliation progress and status breakdown.
class ReconcileMatchMeter extends StatelessWidget {
  final int matchedPercent;
  final int mismatchPercent;
  final int missingPercent;
  final String claimableSummary;

  const ReconcileMatchMeter({
    super.key,
    this.matchedPercent = 70,
    this.mismatchPercent = 15,
    this.missingPercent = 15,
    this.claimableSummary = '84% ITC Claimable',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                StringManager.reconciliationHealth,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                claimableSummary,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: ColorManager.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(flex: matchedPercent, child: Container(height: 10, color: ColorManager.primaryGreen)),
                Expanded(flex: mismatchPercent, child: Container(height: 10, color: Colors.redAccent)),
                Expanded(flex: missingPercent, child: Container(height: 10, color: Colors.orange)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(label: 'Matched ($matchedPercent%)', color: ColorManager.primaryGreen),
              _buildLegend(label: 'Mismatch ($mismatchPercent%)', color: Colors.redAccent),
              _buildLegend(label: 'Missing ($missingPercent%)', color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({required String label, required Color color}) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

