import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Modern Party (Customer / Vendor) Statement Ledger Page.
class PartyLedgerPage extends StatelessWidget {
  const PartyLedgerPage({super.key});

  static const List<Map<String, dynamic>> _ledgerEntries = [
    {
      'date': '01 Oct 2026',
      'particulars': 'Opening Balance b/f',
      'refNo': 'OB/2026-27',
      'debit': '₹ 0.00',
      'credit': '₹ 0.00',
      'balance': '₹ 0.00 Dr',
    },
    {
      'date': '04 Oct 2026',
      'particulars': 'Sales Tax Invoice (Circuit Breakers)',
      'refNo': 'INV-2026-001',
      'debit': '₹ 1,45,000.00',
      'credit': '₹ 0.00',
      'balance': '₹ 1,45,000.00 Dr',
    },
    {
      'date': '15 Oct 2026',
      'particulars': 'Credit Note (Transit Damage)',
      'refNo': 'CN-2026-001',
      'debit': '₹ 0.00',
      'credit': '₹ 12,500.00',
      'balance': '₹ 1,32,500.00 Dr',
    },
    {
      'date': '24 Oct 2026',
      'particulars': 'Bank Inward Receipt (HDFC RTGS)',
      'refNo': 'UTR-HDFC9912',
      'debit': '₹ 0.00',
      'credit': '₹ 1,20,000.00',
      'balance': '₹ 12,500.00 Dr',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Party Statement & Ledger',
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share Statement via WhatsApp',
            onPressed: () => context.showSnackBar('Sharing Ledger PDF via WhatsApp...'),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download PDF',
            onPressed: () => context.showSnackBar('Downloading Ledger PDF...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Party Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GE T&D INDIA LIMITED', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('GSTIN: 05AAACG2115R1ZN • Period: 01 Oct 2026 to 31 Oct 2026', style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                  const Divider(height: 18),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Closing Net Receivable', style: TextStyle(fontSize: 12)),
                      Text('₹ 12,500.00 Dr', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ledger Entries
            ..._ledgerEntries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry['date'], style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        Text(entry['refNo'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ColorManager.primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(entry['particulars'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (entry['debit'] != '₹ 0.00')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Debit (Billed)', style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                              Text(entry['debit'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blue)),
                            ],
                          ),
                        if (entry['credit'] != '₹ 0.00')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Credit (Received)', style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                              Text(entry['credit'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ColorManager.primaryGreen)),
                            ],
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Running Balance', style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                            Text(entry['balance'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

