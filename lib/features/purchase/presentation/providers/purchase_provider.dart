import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';

/// Presentation model representing a Vendor matching the GSTSOF web table columns:
/// SL. No, Action, Vendor Name, GSTIN, Phone/Mobile, Email, State, Payable Balance, Status
class VendorModel {
  final int slNo;
  final String vendorName;
  final String tradeName;
  final String gstin;
  final String pan;
  final String phone;
  final String email;
  final String state;
  final String totalPayable;
  final String status;

  const VendorModel({
    required this.slNo,
    required this.vendorName,
    required this.tradeName,
    required this.gstin,
    required this.pan,
    required this.phone,
    required this.email,
    required this.state,
    required this.totalPayable,
    required this.status,
  });
}

/// Presentation model representing a Purchase Bill matching the GSTSOF web table columns:
/// SL. No, Action, Date, Bill No., Vendor Name, GSTIN, Taxable Value, Total Tax, Total Amount, ITC Status, Due Date
class PurchaseBillModel {
  final int slNo;
  final String billNo;
  final String vendor;
  final String gstin;
  final String date;
  final String taxableValue;
  final String totalTax;
  final String amount;
  final String itcStatus;
  final Color itcColor;
  final String status;
  final String dueDate;

  const PurchaseBillModel({
    required this.slNo,
    required this.billNo,
    required this.vendor,
    required this.gstin,
    required this.date,
    required this.taxableValue,
    required this.totalTax,
    required this.amount,
    required this.itcStatus,
    required this.itcColor,
    required this.status,
    required this.dueDate,
  });
}

class IncomingInvoiceModel {
  final String supplier;
  final String gstin;
  final String invoiceNo;
  final String invoiceDate;
  final String amount;
  final String itcAvailable;
  final String syncStatus;
  final Color syncColor;

  const IncomingInvoiceModel({
    required this.supplier,
    required this.gstin,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.amount,
    required this.itcAvailable,
    required this.syncStatus,
    required this.syncColor,
  });
}

/// Presentation model representing a Debit Note matching the GSTSOF web table columns:
/// SL. No, Action, Date, Debit Note No., Original Bill No., Vendor Name, Reason, Debit Amount, Status
class DebitNoteModel {
  final int slNo;
  final String debitNoteNo;
  final String vendor;
  final String billRef;
  final String date;
  final String reason;
  final String amount;
  final String status;
  final Color statusColor;

  const DebitNoteModel({
    required this.slNo,
    required this.debitNoteNo,
    required this.vendor,
    required this.billRef,
    required this.date,
    required this.reason,
    required this.amount,
    required this.status,
    required this.statusColor,
  });
}

final vendorsListProvider = Provider<List<VendorModel>>((ref) {
  return const [
    VendorModel(
      slNo: 1,
      vendorName: 'Tata Steel Downstream Products',
      tradeName: 'Tata Steel Ltd',
      gstin: '27AAACT2727Q1ZW',
      pan: 'AAACT2727Q',
      phone: '+91 98200 12345',
      email: 'supplies@tatasteel.com',
      state: 'Maharashtra (27)',
      totalPayable: '₹ 3,20,000.00',
      status: 'Active',
    ),
    VendorModel(
      slNo: 2,
      vendorName: 'Schneider Electric India Pvt Ltd',
      tradeName: 'Schneider Electric',
      gstin: '29AAACS4412E1ZZ',
      pan: 'AAACS4412E',
      phone: '+91 98800 67890',
      email: 'procure@se.com',
      state: 'Karnataka (29)',
      totalPayable: '₹ 85,000.00',
      status: 'Active',
    ),
    VendorModel(
      slNo: 3,
      vendorName: 'Larsen & Toubro Electrical',
      tradeName: 'L&T Limited',
      gstin: '27AAACL0149K1ZQ',
      pan: 'AAACL0149K',
      phone: '+91 99300 11223',
      email: 'billing@larsentoubro.com',
      state: 'Maharashtra (27)',
      totalPayable: '₹ 1,12,000.00',
      status: 'Active',
    ),
  ];
});

// Search & Filter Providers for Vendors
final vendorEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final vendorStartDateProvider = StateProvider<String>((ref) => '');
final vendorEndDateProvider = StateProvider<String>((ref) => '');
final vendorSearchByProvider = StateProvider<String>((ref) => 'Vendor Name');
final vendorSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredVendorsProvider = Provider<List<VendorModel>>((ref) {
  final vendors = ref.watch(vendorsListProvider);
  final query = ref.watch(vendorSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(vendorSearchByProvider);

  if (query.isEmpty) return vendors;

  return vendors.where((v) {
    if (searchBy == 'GSTIN') {
      return v.gstin.toLowerCase().contains(query);
    } else if (searchBy == 'Phone') {
      return v.phone.replaceAll(' ', '').contains(query);
    } else {
      return v.vendorName.toLowerCase().contains(query) || v.tradeName.toLowerCase().contains(query);
    }
  }).toList();
});

final purchaseBillsListProvider = Provider<List<PurchaseBillModel>>((ref) {
  return const [
    PurchaseBillModel(
      slNo: 1,
      billNo: 'PB-2026-104',
      vendor: 'Tata Steel Downstream Products',
      gstin: '27AAACT2727Q1ZW',
      date: '22/10/2026',
      taxableValue: '₹ 2,71,186.44',
      totalTax: '₹ 48,813.56',
      amount: '₹ 3,20,000.00',
      itcStatus: 'Eligible ITC',
      itcColor: ColorManager.primaryGreen,
      status: 'Unpaid',
      dueDate: '05/11/2026',
    ),
    PurchaseBillModel(
      slNo: 2,
      billNo: 'PB-2026-098',
      vendor: 'Schneider Electric India',
      gstin: '29AAACS4412E1ZZ',
      date: '17/10/2026',
      taxableValue: '₹ 72,033.90',
      totalTax: '₹ 12,966.10',
      amount: '₹ 85,000.00',
      itcStatus: 'Eligible ITC',
      itcColor: ColorManager.primaryGreen,
      status: 'Paid',
      dueDate: '31/10/2026',
    ),
    PurchaseBillModel(
      slNo: 3,
      billNo: 'PB-2026-085',
      vendor: 'Office Utilities Depot',
      gstin: '19AAACD5544B1Z5',
      date: '10/10/2026',
      taxableValue: '₹ 12,033.90',
      totalTax: '₹ 2,166.10',
      amount: '₹ 14,200.00',
      itcStatus: 'Ineligible ITC',
      itcColor: Colors.grey,
      status: 'Paid',
      dueDate: '24/10/2026',
    ),
  ];
});

// Search & Filter Providers for Purchase Bills
final purchaseEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final purchaseStartDateProvider = StateProvider<String>((ref) => '');
final purchaseEndDateProvider = StateProvider<String>((ref) => '');
final purchaseSearchByProvider = StateProvider<String>((ref) => 'Bill No.');
final purchaseSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredPurchaseBillsProvider = Provider<List<PurchaseBillModel>>((ref) {
  final bills = ref.watch(purchaseBillsListProvider);
  final query = ref.watch(purchaseSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(purchaseSearchByProvider);

  if (query.isEmpty) return bills;

  return bills.where((b) {
    if (searchBy == 'Vendor Name') {
      return b.vendor.toLowerCase().contains(query);
    } else if (searchBy == 'GSTIN') {
      return b.gstin.toLowerCase().contains(query);
    } else {
      return b.billNo.toLowerCase().contains(query);
    }
  }).toList();
});

final incomingInvoicesListProvider = Provider<List<IncomingInvoiceModel>>((ref) {
  return const [
    IncomingInvoiceModel(
      supplier: 'ABB India Limited',
      gstin: '29AABCA2799F1Z1',
      invoiceNo: 'ABB/2026/0491',
      invoiceDate: '23 Oct 2026',
      amount: '₹ 1,84,000.00',
      itcAvailable: '₹ 28,067.00',
      syncStatus: 'Matched in 2B',
      syncColor: ColorManager.primaryGreen,
    ),
    IncomingInvoiceModel(
      supplier: 'Siemens Healthcare Pvt Ltd',
      gstin: '27AAACS2456K1ZZ',
      invoiceNo: 'SIEM/9941',
      invoiceDate: '19 Oct 2026',
      amount: '₹ 92,000.00',
      itcAvailable: '₹ 14,033.00',
      syncStatus: 'Missing in Books',
      syncColor: Colors.orange,
    ),
  ];
});

final debitNotesListProvider = Provider<List<DebitNoteModel>>((ref) {
  return const [
    DebitNoteModel(
      slNo: 1,
      debitNoteNo: 'DN-2026-001',
      vendor: 'Tata Steel Downstream Products',
      billRef: 'PB-2026-104',
      date: '24/10/2026',
      reason: 'Quality Rejection / Substandard Material',
      amount: '₹ 45,000.00',
      status: 'Accepted',
      statusColor: ColorManager.primaryGreen,
    ),
  ];
});

// Search & Filter Providers for Debit Notes
final debitNoteEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final debitNoteStartDateProvider = StateProvider<String>((ref) => '');
final debitNoteEndDateProvider = StateProvider<String>((ref) => '');
final debitNoteSearchByProvider = StateProvider<String>((ref) => 'Debit Note No.');
final debitNoteSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredDebitNotesProvider = Provider<List<DebitNoteModel>>((ref) {
  final notes = ref.watch(debitNotesListProvider);
  final query = ref.watch(debitNoteSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(debitNoteSearchByProvider);

  if (query.isEmpty) return notes;

  return notes.where((n) {
    if (searchBy == 'Vendor Name') {
      return n.vendor.toLowerCase().contains(query);
    } else if (searchBy == 'Bill Ref') {
      return n.billRef.toLowerCase().contains(query);
    } else {
      return n.debitNoteNo.toLowerCase().contains(query);
    }
  }).toList();
});
