import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Quick Actions widget matching the web dashboard quick action tiles.
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
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
          Text(
            'Quick Actions',
            style: getBoldStyle(
              fontSize: FontManager.s18,
              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              _buildActionTile(context, icon: Icons.description_outlined, label: 'Create Invoice', color: Colors.green, isDark: isDark),
              _buildActionTile(context, icon: Icons.shopping_cart_outlined, label: 'Create Purchase', color: Colors.blue, isDark: isDark),
              _buildActionTile(context, icon: Icons.payments_outlined, label: 'Record Payment', color: Colors.teal, isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required IconData icon, required String label, required Color color, required bool isDark}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontSize: FontManager.s12,
                color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
