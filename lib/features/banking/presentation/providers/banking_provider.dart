import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccountModel {
  final int slNo;
  final String bankName;
  final String accountNo;
  final String ifsc;
  final String branch;
  final String balance;
  final String accountType;
  final List<Color> cardGradient;

  const BankAccountModel({
    required this.slNo,
    required this.bankName,
    required this.accountNo,
    required this.ifsc,
    required this.branch,
    required this.balance,
    required this.accountType,
    required this.cardGradient,
  });
}

/// Presentation model representing a Bank Transaction matching the GSTSOF web table columns:
/// SL. No, Action, Date, Account Name, Type, Ref / Cheque No., Party, Debit (Dr), Credit (Cr), Balance, Status
class BankTransactionModel {
  final int slNo;
  final String title;
  final String accountName;
  final String mode;
  final String date;
  final String ref;
  final String party;
  final String amount;
  final String balance;
  final bool isCredit;
  final String status;

  const BankTransactionModel({
    required this.slNo,
    required this.title,
    required this.accountName,
    required this.mode,
    required this.date,
    required this.ref,
    required this.party,
    required this.amount,
    required this.balance,
    required this.isCredit,
    required this.status,
  });
}

/// Expense Item Model matching exact fields from GSTSOF web table:
/// SL. No, Date, EXP No., Party, Payment, Amount, Due Date, Action
class ExpenseModel {
  final int slNo;
  final String expNo;
  final String date;
  final String party;
  final String paymentMode;
  final String amount;
  final String dueDate;
  final String category;
  final bool gstClaimable;

  const ExpenseModel({
    required this.slNo,
    required this.expNo,
    required this.date,
    required this.party,
    required this.paymentMode,
    required this.amount,
    required this.dueDate,
    required this.category,
    this.gstClaimable = false,
  });
}

/// Expense Category Model matching exact fields from GSTSOF web table:
/// SL. No, Category Name, Description, Status, Action
class ExpenseCategoryModel {
  final int slNo;
  final String name;
  final String description;
  final String status;
  final bool isActive;

  const ExpenseCategoryModel({
    required this.slNo,
    required this.name,
    required this.description,
    required this.status,
    this.isActive = true,
  });
}

class IncomeModel {
  final String title;
  final String source;
  final String date;
  final String amount;

  const IncomeModel({
    required this.title,
    required this.source,
    required this.date,
    required this.amount,
  });
}

final incomeListProvider = Provider<List<IncomeModel>>((ref) {
  return const [
    IncomeModel(
      title: 'Consultancy Retainer Fee',
      source: 'Direct Consultancy',
      date: '23/10/2026',
      amount: '₹ 75,000.00',
    ),
    IncomeModel(
      title: 'Fixed Deposit Quarterly Interest',
      source: 'HDFC Bank FD',
      date: '15/10/2026',
      amount: '₹ 18,250.00',
    ),
  ];
});

final bankAccountsProvider = Provider<List<BankAccountModel>>((ref) {
  return const [
    BankAccountModel(
      slNo: 1,
      bankName: 'HDFC Bank - Current A/C',
      accountNo: '•••• •••• 9012',
      ifsc: 'HDFC0001234',
      branch: 'Fort Branch, Mumbai',
      balance: '₹ 38,42,500.00',
      accountType: 'Current',
      cardGradient: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    ),
    BankAccountModel(
      slNo: 2,
      bankName: 'State Bank of India - OD A/C',
      accountNo: '•••• •••• 4589',
      ifsc: 'SBIN0005678',
      branch: 'Connaught Place, New Delhi',
      balance: '₹ 16,80,250.00',
      accountType: 'Overdraft',
      cardGradient: [Color(0xFF134E5E), Color(0xFF71B280)],
    ),
    BankAccountModel(
      slNo: 3,
      bankName: 'ICICI Bank - Escrow A/C',
      accountNo: '•••• •••• 7731',
      ifsc: 'ICIC0009988',
      branch: 'Bandra Kurla Complex',
      balance: '₹ 5,31,795.00',
      accountType: 'Escrow',
      cardGradient: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
    ),
  ];
});

final bankTransactionsProvider = Provider<List<BankTransactionModel>>((ref) {
  return const [
    BankTransactionModel(
      slNo: 1,
      title: 'Payment Received from GE T&D INDIA',
      accountName: 'HDFC Bank - Current A/C',
      mode: 'NEFT / RTGS',
      date: '24/10/2026',
      ref: 'UTR: HDFC2610249912',
      party: 'GE T&D INDIA LIMITED',
      amount: '+ ₹ 1,20,000.00',
      balance: '₹ 38,42,500.00',
      isCredit: true,
      status: 'Matched',
    ),
    BankTransactionModel(
      slNo: 2,
      title: 'Vendor Payment to Tata Steel Ltd',
      accountName: 'HDFC Bank - Current A/C',
      mode: 'Net Banking',
      date: '22/10/2026',
      ref: 'UTR: HDFC2610228831',
      party: 'Tata Steel Downstream Products',
      amount: '- ₹ 85,000.00',
      balance: '₹ 37,22,500.00',
      isCredit: false,
      status: 'Matched',
    ),
    BankTransactionModel(
      slNo: 3,
      title: 'Client Advance from Sharma Enterprises',
      accountName: 'SBI - OD A/C',
      mode: 'UPI Business',
      date: '20/10/2026',
      ref: 'UPI: 429188291039',
      party: 'Sharma Enterprises',
      amount: '+ ₹ 48,500.00',
      balance: '₹ 16,80,250.00',
      isCredit: true,
      status: 'Matched',
    ),
    BankTransactionModel(
      slNo: 4,
      title: 'Office Electricity & Power Bill',
      accountName: 'SBI - OD A/C',
      mode: 'Auto-Debit',
      date: '18/10/2026',
      ref: 'ACH: MSEDCL9921',
      party: 'MSEDCL Mumbai',
      amount: '- ₹ 12,450.00',
      balance: '₹ 16,31,750.00',
      isCredit: false,
      status: 'Reconciled',
    ),
  ];
});

// Transaction filter providers
final transactionEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final transactionStartDateProvider = StateProvider<String>((ref) => '');
final transactionEndDateProvider = StateProvider<String>((ref) => '');
final transactionSearchByProvider = StateProvider<String>((ref) => 'Ref / No.');
final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTransactionsProvider = Provider<List<BankTransactionModel>>((ref) {
  final txns = ref.watch(bankTransactionsProvider);
  final query = ref.watch(transactionSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(transactionSearchByProvider);

  if (query.isEmpty) return txns;

  return txns.where((t) {
    if (searchBy == 'Party') {
      return t.party.toLowerCase().contains(query);
    } else if (searchBy == 'Account') {
      return t.accountName.toLowerCase().contains(query);
    } else {
      return t.ref.toLowerCase().contains(query) || t.title.toLowerCase().contains(query);
    }
  }).toList();
});

// Expense filter state providers
final expenseSelectedTabProvider = StateProvider<int>((ref) => 1); // 0 = Category, 1 = Item
final expenseEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final expenseStartDateProvider = StateProvider<String>((ref) => '');
final expenseEndDateProvider = StateProvider<String>((ref) => '');
final expenseSearchByProvider = StateProvider<String>((ref) => 'Expense No.');
final expenseSearchQueryProvider = StateProvider<String>((ref) => '');

final allExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  return const [
    ExpenseModel(
      slNo: 1,
      expNo: 'EXP-2026-001',
      date: '24/10/2026',
      party: 'Skyline Commercial Properties LLP',
      paymentMode: 'Bank Transfer (HDFC)',
      amount: '₹ 45,000.00',
      dueDate: '05/11/2026',
      category: 'Rent & Utilities',
      gstClaimable: true,
    ),
    ExpenseModel(
      slNo: 2,
      expNo: 'EXP-2026-002',
      date: '20/10/2026',
      party: 'Staff Payroll & Engineering Operations',
      paymentMode: 'Net Banking',
      amount: '₹ 1,80,000.00',
      dueDate: '30/10/2026',
      category: 'Staff Salaries',
      gstClaimable: false,
    ),
    ExpenseModel(
      slNo: 3,
      expNo: 'EXP-2026-003',
      date: '16/10/2026',
      party: 'Tata Tele & AWS Cloud India',
      paymentMode: 'Credit Card',
      amount: '₹ 18,500.00',
      dueDate: '28/10/2026',
      category: 'Internet & Cloud Hosting',
      gstClaimable: true,
    ),
  ];
});

final allExpenseCategoriesProvider = Provider<List<ExpenseCategoryModel>>((ref) {
  return const [
    ExpenseCategoryModel(
      slNo: 1,
      name: 'Rent & Property Rates',
      description: 'Office warehouse space and godown lease charges',
      status: 'Active',
      isActive: true,
    ),
    ExpenseCategoryModel(
      slNo: 2,
      name: 'Salaries & Staff Allowances',
      description: 'Employee wages, professional consultancy and benefits',
      status: 'Active',
      isActive: true,
    ),
    ExpenseCategoryModel(
      slNo: 3,
      name: 'Software & Cloud Services',
      description: 'SaaS tools, accounting software and cloud hosting',
      status: 'Active',
      isActive: true,
    ),
  ];
});

final filteredExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final expenses = ref.watch(allExpensesProvider);
  final query = ref.watch(expenseSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(expenseSearchByProvider);

  if (query.isEmpty) return expenses;

  return expenses.where((exp) {
    if (searchBy == 'Party') {
      return exp.party.toLowerCase().contains(query);
    } else if (searchBy == 'Category') {
      return exp.category.toLowerCase().contains(query);
    } else {
      return exp.expNo.toLowerCase().contains(query);
    }
  }).toList();
});

final filteredExpenseCategoriesProvider = Provider<List<ExpenseCategoryModel>>((ref) {
  final categories = ref.watch(allExpenseCategoriesProvider);
  final query = ref.watch(expenseSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return categories;

  return categories.where((cat) {
    return cat.name.toLowerCase().contains(query) || cat.description.toLowerCase().contains(query);
  }).toList();
});
