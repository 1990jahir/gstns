import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';

/// Purchase Invoices tab widget with search, filters, and mobile cards.
class PurchaseInvoicesTab extends StatelessWidget {
  const PurchaseInvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Search & Action Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? ColorManager.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search invoice no, vendor...',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRouter.createInvoice),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text('Create', style: getBoldStyle(fontSize: FontManager.s13, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),

        // List of Purchase Invoices Cards
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              _buildInvoiceCard(
                context,
                invoiceNo: 'URP/2026-27/1',
                date: '16/10/2026',
                vendor: 'GE T&D INDIA LIMITED',
                taxable: '₹ 4,54,54,545.00',
                total: '₹ 4,54,54,545.00',
                status: 'Approved',
                isDark: isDark,
              ),
              _buildInvoiceCard(
                context,
                invoiceNo: 'URP/2026-27/2',
                date: '18/10/2026',
                vendor: 'Sharma Enterprises',
                taxable: '₹ 48,500.00',
                total: '₹ 50,000.00',
                status: 'Pending',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceCard(BuildContext context, {required String invoiceNo, required String date, required String vendor, required String taxable, required String total, required String status, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
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
              Text(
                invoiceNo,
                style: getBoldStyle(
                  fontSize: FontManager.s16,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'Approved' ? Colors.green.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: getBoldStyle(
                    fontSize: FontManager.s12,
                    color: status == 'Approved' ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            vendor,
            style: getRegularStyle(
              fontSize: FontManager.s13,
              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice Date', style: getRegularStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
                  const SizedBox(height: 2),
                  Text(date, style: getMediumStyle(fontSize: FontManager.s13, color: isDark ? Colors.white : Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Taxable Amount', style: getRegularStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
                  const SizedBox(height: 2),
                  Text(taxable, style: getMediumStyle(fontSize: FontManager.s13, color: Colors.blue)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Amount', style: getRegularStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
                  const SizedBox(height: 2),
                  Text(total, style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
