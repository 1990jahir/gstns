import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';

/// Presentation model representing a Tax Invoice matching the GSTSOF web table columns:
/// SL. No, Action, Date, Invoice No., Customer Name, GSTIN, Taxable Amount, Total Tax, Invoice Amount, Status, Due Date
class InvoiceModel {
  final int slNo;
  final String invoiceNo;
  final String date;
  final String customerName;
  final String gstin;
  final String taxableAmount;
  final String totalTax;
  final String invoiceAmount;
  final String status;
  final String dueDate;
  final Color statusColor;

  const InvoiceModel({
    required this.slNo,
    required this.invoiceNo,
    required this.date,
    required this.customerName,
    required this.gstin,
    required this.taxableAmount,
    required this.totalTax,
    required this.invoiceAmount,
    required this.status,
    required this.dueDate,
    required this.statusColor,
  });
}

/// Presentation model representing a Credit Note matching the GSTSOF web table columns:
/// SL. No, Action, Date, Credit Note No., Original Invoice No., Customer Name, Reason, Credit Amount, Status
class CreditNoteModel {
  final int slNo;
  final String creditNoteNo;
  final String originalInvoice;
  final String partyName;
  final String date;
  final String reason;
  final String amount;
  final String status;
  final Color statusColor;

  const CreditNoteModel({
    required this.slNo,
    required this.creditNoteNo,
    required this.originalInvoice,
    required this.partyName,
    required this.date,
    required this.reason,
    required this.amount,
    required this.status,
    required this.statusColor,
  });
}

/// Presentation model representing a Delivery Challan matching the GSTSOF web table columns:
/// SL. No, Action, Date, Challan No., Consignee Name, Vehicle No., Goods Type, Approximate Value, Status
class DeliveryChallanModel {
  final int slNo;
  final String challanNo;
  final String receiverName;
  final String date;
  final String vehicleNo;
  final String goodsType;
  final String approxValue;
  final String status;
  final Color statusColor;

  const DeliveryChallanModel({
    required this.slNo,
    required this.challanNo,
    required this.receiverName,
    required this.date,
    required this.vehicleNo,
    required this.goodsType,
    required this.approxValue,
    required this.status,
    required this.statusColor,
  });
}

final invoicesProvider = Provider<List<InvoiceModel>>((ref) {
  return const [
    InvoiceModel(
      slNo: 1,
      invoiceNo: 'INV-2026-001',
      date: '24/10/2026',
      customerName: 'GE T&D INDIA LIMITED',
      gstin: '05AAACG2115R1ZN',
      taxableAmount: '₹ 1,22,881.35',
      totalTax: '₹ 22,118.65',
      invoiceAmount: '₹ 1,45,000.00',
      status: 'Unpaid',
      dueDate: '07/11/2026',
      statusColor: Colors.orange,
    ),
    InvoiceModel(
      slNo: 2,
      invoiceNo: 'INV-2026-002',
      date: '20/10/2026',
      customerName: 'Sharma Enterprises',
      gstin: '07AABCS1429B1Z8',
      taxableAmount: '₹ 41,101.69',
      totalTax: '₹ 7,398.31',
      invoiceAmount: '₹ 48,500.00',
      status: 'Paid',
      dueDate: '04/11/2026',
      statusColor: ColorManager.primaryGreen,
    ),
    InvoiceModel(
      slNo: 3,
      invoiceNo: 'INV-2026-003',
      date: '15/10/2026',
      customerName: 'Bengal Tech Solutions',
      gstin: '19AABCB2231C1ZS',
      taxableAmount: '₹ 2,37,288.14',
      totalTax: '₹ 42,711.86',
      invoiceAmount: '₹ 2,80,000.00',
      status: 'Overdue',
      dueDate: '29/10/2026',
      statusColor: Colors.redAccent,
    ),
  ];
});

// Search & Filter Providers for Invoices
final invoiceEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final invoiceStartDateProvider = StateProvider<String>((ref) => '');
final invoiceEndDateProvider = StateProvider<String>((ref) => '');
final invoiceSearchByProvider = StateProvider<String>((ref) => 'Invoice No.');
final invoiceSearchQueryProvider = StateProvider<String>((ref) => '');
final invoiceStatusFilterProvider = StateProvider<String>((ref) => 'All');

final filteredInvoicesProvider = Provider<List<InvoiceModel>>((ref) {
  final invoices = ref.watch(invoicesProvider);
  final query = ref.watch(invoiceSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(invoiceSearchByProvider);
  final status = ref.watch(invoiceStatusFilterProvider);

  var list = invoices;
  if (status != 'All') {
    list = list.where((i) => i.status == status).toList();
  }

  if (query.isEmpty) return list;

  return list.where((i) {
    if (searchBy == 'Customer Name') {
      return i.customerName.toLowerCase().contains(query);
    } else if (searchBy == 'GSTIN') {
      return i.gstin.toLowerCase().contains(query);
    } else {
      return i.invoiceNo.toLowerCase().contains(query);
    }
  }).toList();
});

// Credit Notes Providers
final creditNotesProvider = Provider<List<CreditNoteModel>>((ref) {
  return const [
    CreditNoteModel(
      slNo: 1,
      creditNoteNo: 'CN-2026-01',
      originalInvoice: 'INV-2026-001',
      partyName: 'GE T&D INDIA LIMITED',
      date: '25/10/2026',
      reason: 'Goods Damaged in Transit',
      amount: '₹ 12,500.00',
      status: 'Issued',
      statusColor: ColorManager.primaryGreen,
    ),
    CreditNoteModel(
      slNo: 2,
      creditNoteNo: 'CN-2026-02',
      originalInvoice: 'INV-2026-003',
      partyName: 'Bengal Tech Solutions',
      date: '22/10/2026',
      reason: 'Rate Difference in Line Items',
      amount: '₹ 5,200.00',
      status: 'Pending',
      statusColor: Colors.orange,
    ),
  ];
});

final creditNoteEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final creditNoteStartDateProvider = StateProvider<String>((ref) => '');
final creditNoteEndDateProvider = StateProvider<String>((ref) => '');
final creditNoteSearchByProvider = StateProvider<String>((ref) => 'Credit Note No.');
final creditNoteSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCreditNotesProvider = Provider<List<CreditNoteModel>>((ref) {
  final notes = ref.watch(creditNotesProvider);
  final query = ref.watch(creditNoteSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(creditNoteSearchByProvider);

  if (query.isEmpty) return notes;

  return notes.where((n) {
    if (searchBy == 'Customer Name') {
      return n.partyName.toLowerCase().contains(query);
    } else if (searchBy == 'Invoice No.') {
      return n.originalInvoice.toLowerCase().contains(query);
    } else {
      return n.creditNoteNo.toLowerCase().contains(query);
    }
  }).toList();
});

// Delivery Challans Providers
final deliveryChallansProvider = Provider<List<DeliveryChallanModel>>((ref) {
  return const [
    DeliveryChallanModel(
      slNo: 1,
      challanNo: 'DC-2026-088',
      receiverName: 'Apex Logistics Godown 4',
      date: '26/10/2026',
      vehicleNo: 'WB 26 B 8891',
      goodsType: 'Electrical Switchgears',
      approxValue: '₹ 3,45,000.00',
      status: 'In Transit',
      statusColor: Colors.blue,
    ),
    DeliveryChallanModel(
      slNo: 2,
      challanNo: 'DC-2026-089',
      receiverName: 'Kolkata Metro Project Site',
      date: '24/10/2026',
      vehicleNo: 'WB 19 C 1204',
      goodsType: 'Copper Armoured Cables',
      approxValue: '₹ 1,80,000.00',
      status: 'Delivered',
      statusColor: ColorManager.primaryGreen,
    ),
  ];
});

final challanEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final challanStartDateProvider = StateProvider<String>((ref) => '');
final challanEndDateProvider = StateProvider<String>((ref) => '');
final challanSearchByProvider = StateProvider<String>((ref) => 'Challan No.');
final challanSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredDeliveryChallansProvider = Provider<List<DeliveryChallanModel>>((ref) {
  final challans = ref.watch(deliveryChallansProvider);
  final query = ref.watch(challanSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(challanSearchByProvider);

  if (query.isEmpty) return challans;

  return challans.where((c) {
    if (searchBy == 'Consignee') {
      return c.receiverName.toLowerCase().contains(query);
    } else if (searchBy == 'Vehicle No.') {
      return c.vehicleNo.toLowerCase().contains(query);
    } else {
      return c.challanNo.toLowerCase().contains(query);
    }
  }).toList();
});
