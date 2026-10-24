import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Client-Choice Quick Actions & Import Banner Card
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    final actions = [
      {
        'label': 'Create\nInvoice',
        'icon': Icons.post_add_rounded,
        'color': const Color(0xFF16A34A),
        'bgColor': const Color(0xFFDCFCE7),
      },
      {
        'label': 'Create\nPurchase',
        'icon': Icons.shopping_bag_outlined,
        'color': const Color(0xFFEA580C),
        'bgColor': const Color(0xFFFFEDD5),
      },
      {
        'label': 'E-Way Bill',
        'icon': Icons.local_shipping_outlined,
        'color': const Color(0xFF0284C7),
        'bgColor': const Color(0xFFE0F2FE),
      },
      {
        'label': 'Record\nPayment',
        'icon': Icons.payments_outlined,
        'color': const Color(0xFF0D9488),
        'bgColor': const Color(0xFFCCFBF1),
      },
      {
        'label': 'Add\nExpense',
        'icon': Icons.receipt_long_outlined,
        'color': const Color(0xFFE11D48),
        'bgColor': const Color(0xFFFCE7F3),
      },
      {
        'label': 'GST Filing',
        'icon': Icons.currency_rupee_rounded,
        'color': const Color(0xFF9333EA),
        'bgColor': const Color(0xFFF3E8FF),
      },
    ];

    return Column(
      children: [
        // Quick Actions Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isDark ? ColorManager.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              Text(
                'Quick Actions',
                style: getBoldStyle(
                  fontSize: FontManager.s16,
                  color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: actions.map((act) {
                    final color = act['color'] as Color;
                    final bgColor = act['bgColor'] as Color;
                    final label = act['label'] as String;
                    final icon = act['icon'] as IconData;

                    return Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: InkWell(
                        onTap: () => context.showSnackBar('$label clicked'),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDark ? color.withValues(alpha: 0.2) : bgColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icon, color: color, size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: getMediumStyle(
                                fontSize: FontManager.s11,
                                color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Import Banner Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C1E18) : const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF7C2D12).withValues(alpha: 0.4) : const Color(0xFFFFEDD5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Color(0xFFEA580C),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save time! Import your invoices',
                      style: getBoldStyle(
                        fontSize: FontManager.s13,
                        color: isDark ? Colors.white : const Color(0xFF7C2D12),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Upload and manage invoices in bulk',
                      style: getRegularStyle(
                        fontSize: FontManager.s11,
                        color: isDark ? const Color(0xFFD6D3D1) : const Color(0xFF9A3412),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.showSnackBar('Import Invoices opened'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2410C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Import Now',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
