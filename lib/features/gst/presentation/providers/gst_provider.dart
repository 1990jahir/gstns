import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';

class Gstr1SectionModel {
  final String code;
  final String title;
  final String count;
  final String taxableValue;
  final String totalTax;

  const Gstr1SectionModel({
    required this.code,
    required this.title,
    required this.count,
    required this.taxableValue,
    required this.totalTax,
  });
}

class Gstr3bSummarySectionModel {
  final String title;
  final List<Map<String, String>> items;

  const Gstr3bSummarySectionModel({
    required this.title,
    required this.items,
  });
}

class Gstr2bReconcileItemModel {
  final String supplier;
  final String invoiceNo;
  final String date;
  final String booksTax;
  final String portalTax;
  final String status;
  final Color statusColor;
  final String discrepancy;

  const Gstr2bReconcileItemModel({
    required this.supplier,
    required this.invoiceNo,
    required this.date,
    required this.booksTax,
    required this.portalTax,
    required this.status,
    required this.statusColor,
    required this.discrepancy,
  });
}

final gstr1SectionsProvider = Provider<List<Gstr1SectionModel>>((ref) {
  return const [
    Gstr1SectionModel(
      code: '4A, 4B, 6B, 6C',
      title: 'B2B Taxable Invoices',
      count: '3 Invoices',
      taxableValue: '₹ 4,73,500.00',
      totalTax: '₹ 85,230.00',
    ),
    Gstr1SectionModel(
      code: '5A, 5B',
      title: 'B2C (Large) Invoices',
      count: '0 Invoices',
      taxableValue: '₹ 0.00',
      totalTax: '₹ 0.00',
    ),
    Gstr1SectionModel(
      code: '7',
      title: 'B2C (Small) Invoices',
      count: '1 Invoice',
      taxableValue: '₹ 41,101.69',
      totalTax: '₹ 7,398.31',
    ),
    Gstr1SectionModel(
      code: '9B',
      title: 'Credit / Debit Notes (Registered)',
      count: '2 Notes',
      taxableValue: '₹ 20,500.00',
      totalTax: '₹ 3,690.00',
    ),
    Gstr1SectionModel(
      code: '12',
      title: 'HSN-Wise Summary of Outward Supplies',
      count: '4 HSNs',
      taxableValue: '₹ 5,14,601.69',
      totalTax: '₹ 92,628.31',
    ),
  ];
});

final gstr3bSectionsProvider = Provider<List<Gstr3bSummarySectionModel>>((ref) {
  return const [
    Gstr3bSummarySectionModel(
      title: '3.1 Details of Outward Supplies & RCM',
      items: [
        {'label': 'Total Taxable Value', 'val': '₹ 5,14,601.69'},
        {'label': 'Integrated Tax (IGST)', 'val': '₹ 45,200.00'},
        {'label': 'Central Tax (CGST)', 'val': '₹ 23,714.15'},
        {'label': 'State Tax (SGST)', 'val': '₹ 23,714.15'},
      ],
    ),
    Gstr3bSummarySectionModel(
      title: '4. Eligible Input Tax Credit (ITC)',
      items: [
        {'label': 'ITC on Import of Goods', 'val': '₹ 0.00'},
        {'label': 'ITC from Registered Suppliers (2B)', 'val': '₹ 58,498.31'},
        {'label': 'Ineligible ITC (Sec 17(5))', 'val': '₹ 0.00'},
      ],
    ),
  ];
});

final gstr2bReconcileItemsProvider = Provider<List<Gstr2bReconcileItemModel>>((ref) {
  return const [
    Gstr2bReconcileItemModel(
      supplier: 'ABB India Limited',
      invoiceNo: 'ABB/2026/0491',
      date: '23 Oct 2026',
      booksTax: '₹ 28,067.00',
      portalTax: '₹ 28,067.00',
      status: 'Matched',
      statusColor: ColorManager.primaryGreen,
      discrepancy: 'None - Perfect Match',
    ),
    Gstr2bReconcileItemModel(
      supplier: 'Schneider Electric India',
      invoiceNo: 'SE/99120',
      date: '17 Oct 2026',
      booksTax: '₹ 15,300.00',
      portalTax: '₹ 12,960.00',
      status: 'Mismatch',
      statusColor: Colors.redAccent,
      discrepancy: 'Tax rate difference in GSTR-1 by vendor (18% vs 12%)',
    ),
    Gstr2bReconcileItemModel(
      supplier: 'Siemens Healthcare Pvt Ltd',
      invoiceNo: 'SIEM/9941',
      date: '19 Oct 2026',
      booksTax: '₹ 14,033.00',
      portalTax: '₹ 0.00',
      status: 'Missing in 2B',
      statusColor: Colors.orange,
      discrepancy: 'Vendor has not filed GSTR-1 for October 2026',
    ),
  ];
});

final reconcileFilterProvider = StateProvider<String>((ref) => 'All');

final filteredGstr2bItemsProvider = Provider<List<Gstr2bReconcileItemModel>>((ref) {
  final filter = ref.watch(reconcileFilterProvider);
  final items = ref.watch(gstr2bReconcileItemsProvider);
  if (filter == 'All') return items;
  return items.where((it) => it.status == filter).toList();
});
