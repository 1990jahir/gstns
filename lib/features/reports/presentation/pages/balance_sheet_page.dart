import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Modern Balance Sheet Financial Statement Page.
class BalanceSheetPage extends StatelessWidget {
  const BalanceSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.balanceSheetTitle,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => context.showSnackBar('Downloading Balance Sheet PDF...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Statement Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
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
                  Text(
                    'Balance Sheet as on 31 October 2026',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹ 1,48,50,000.00',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontFamily: 'Inter',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Total Assets = Total Liabilities (Balanced)',
                    style: TextStyle(fontSize: 12, color: ColorManager.primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ASSETS
            _buildScheduleCard(
              title: 'ASSETS',
              color: ColorManager.primaryGreen,
              items: [
                {'name': 'Fixed Assets (Plant & Machinery, Computers)', 'amount': '₹ 45,20,000.00'},
                {'name': 'Current Assets (Closing Stock / Inventory)', 'amount': '₹ 38,50,455.00'},
                {'name': 'Sundry Debtors (Customer Receivables)', 'amount': '₹ 4,25,000.00'},
                {'name': 'Bank Liquidity & Cash in Hand', 'amount': '₹ 60,54,545.00'},
              ],
              total: '₹ 1,48,50,000.00',
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // LIABILITIES & EQUITY
            _buildScheduleCard(
              title: 'EQUITY & LIABILITIES',
              color: Colors.blue,
              items: [
                {'name': 'Capital Account (Owner’s Equity)', 'amount': '₹ 80,00,000.00'},
                {'name': 'Retained Earnings & Reserves', 'amount': '₹ 42,15,000.00'},
                {'name': 'Sundry Creditors (Vendor Payables)', 'amount': '₹ 5,17,000.00'},
                {'name': 'Duties & Taxes (GST Payable to Govt)', 'amount': '₹ 34,130.00'},
                {'name': 'Short-Term Provisions & Expenses Payable', 'amount': '₹ 20,83,870.00'},
              ],
              total: '₹ 1,48,50,000.00',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required Color color,
    required List<Map<String, String>> items,
    required String total,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                total,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...items.map((it) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      it['name']!,
                      style: TextStyle(fontSize: 12.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563)),
                    ),
                  ),
                  Text(
                    it['amount']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

