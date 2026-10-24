import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/widgets/global_input_field.dart';
import '../../../../core/utils/extensions.dart';

/// Incoming Invoices tab widget with search and mobile cards.
class IncomingInvoicesTab extends StatelessWidget {
  const IncomingInvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: const GlobalInputField(
            label: 'Search incoming invoice no, ack no...',
            prefixIcon: Icons.search_rounded,
          ),
        ),

        // List of Incoming Invoices Cards
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              _buildIncomingCard(
                context,
                invoiceNo: 'INC/2026-27/89',
                ackNo: 'ACK98237498237',
                date: '15/10/2026',
                company: 'Bengal Tech Solutions',
                taxable: '₹ 1,20,000.00',
                total: '₹ 1,41,600.00',
                status: 'Received',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomingCard(BuildContext context, {required String invoiceNo, required String ackNo, required String date, required String company, required String taxable, required String total, required String status, required bool isDark}) {
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
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: getBoldStyle(fontSize: FontManager.s11, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('ACK: $ackNo', style: getRegularStyle(fontSize: FontManager.s12, color: ColorManager.grey)),
          const SizedBox(height: 8),
          Text(
            company,
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
                  Text('Invoice Date', style: getRegularStyle(fontSize: FontManager.s11, color: ColorManager.grey)),
                  const SizedBox(height: 2),
                  Text(date, style: getMediumStyle(fontSize: FontManager.s13, color: isDark ? Colors.white : Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Amount', style: getRegularStyle(fontSize: FontManager.s11, color: ColorManager.grey)),
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
