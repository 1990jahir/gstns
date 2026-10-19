import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Quick Actions widget matching the reference screenshot 4 tiles (Create Invoice, Create Purchase, Record Payment, Add Expense).
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringManager.quickActions,
            style: getBoldStyle(
              fontSize: FontManager.s18,
              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.4,
            children: [
              _buildActionTile(context, icon: Icons.description_outlined, label: StringManager.createInvoice, color: Colors.green, isDark: isDark),
              _buildActionTile(context, icon: Icons.shopping_cart_outlined, label: StringManager.createPurchase, color: Colors.blue, isDark: isDark),
              _buildActionTile(context, icon: Icons.payments_outlined, label: StringManager.recordPayment, color: Colors.teal, isDark: isDark),
              _buildActionTile(context, icon: Icons.account_balance_wallet_outlined, label: 'Add Expense', color: Colors.orange, isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required IconData icon, required String label, required Color color, required bool isDark}) {
    return InkWell(
      onTap: () => context.showSnackBar('$label clicked'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontManager.s13,
                color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
