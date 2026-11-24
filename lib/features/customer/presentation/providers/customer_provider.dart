import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/customer_repository.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository());

/// Model representing a customer matching the GSTSOF web portal table columns:
/// SL. No, Action, Customer Name, GSTIN/UIN, Mobile No., Email, City/State, Outstanding Balance, Status
class CustomerModel {
  final int slNo;
  final String customerName;
  final String companyName;
  final String gstin;
  final String mobile;
  final String email;
  final String state;
  final String type; // B2B or B2C
  final String outstandingBalance;
  final String status;

  const CustomerModel({
    required this.slNo,
    required this.customerName,
    required this.companyName,
    required this.gstin,
    required this.mobile,
    required this.email,
    required this.state,
    required this.type,
    required this.outstandingBalance,
    required this.status,
  });
}

final customerListProvider = StateProvider<List<CustomerModel>>((ref) {
  return [
    const CustomerModel(
      slNo: 1,
      customerName: 'GE T&D INDIA LIMITED',
      companyName: 'GE Power Systems',
      gstin: '05AAACG2115R1ZN',
      mobile: '+91 94773 17207',
      email: 'contact@ged.com',
      state: 'Uttarakhand (05)',
      type: 'B2B',
      outstandingBalance: '₹ 25,000.00',
      status: 'Active',
    ),
    const CustomerModel(
      slNo: 2,
      customerName: 'Aarav Sharma',
      companyName: 'Sharma Enterprises',
      gstin: '07AABCS1429B1Z8',
      mobile: '+91 98765 43210',
      email: 'aarav.sharma@gmail.com',
      state: 'Delhi (07)',
      type: 'B2C',
      outstandingBalance: '₹ 0.00',
      status: 'Active',
    ),
    const CustomerModel(
      slNo: 3,
      customerName: 'Priya Mukherjee',
      companyName: 'Bengal Tech Solutions',
      gstin: '19AABCB2231C1ZS',
      mobile: '+91 91234 56789',
      email: 'info@bengaltech.io',
      state: 'West Bengal (19)',
      type: 'B2B',
      outstandingBalance: '₹ 1,30,000.00',
      status: 'Active',
    ),
  ];
});

// Search & Filter state providers
final customerEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final customerStartDateProvider = StateProvider<String>((ref) => '');
final customerEndDateProvider = StateProvider<String>((ref) => '');
final customerSearchByProvider = StateProvider<String>((ref) => 'Customer Name');
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCustomersProvider = Provider<List<CustomerModel>>((ref) {
  final customers = ref.watch(customerListProvider);
  final query = ref.watch(customerSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(customerSearchByProvider);

  if (query.isEmpty) return customers;

  return customers.where((c) {
    if (searchBy == 'GSTIN') {
      return c.gstin.toLowerCase().contains(query);
    } else if (searchBy == 'Mobile') {
      return c.mobile.replaceAll(' ', '').contains(query);
    } else {
      return c.customerName.toLowerCase().contains(query) ||
             c.companyName.toLowerCase().contains(query);
    }
  }).toList();
});

class CustomerState {
  final bool isLoading;
  final String? errorMessage;

  CustomerState({this.isLoading = false, this.errorMessage});

  CustomerState copyWith({bool? isLoading, String? errorMessage}) {
    return CustomerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerRepository _repository;

  CustomerNotifier(this._repository) : super(CustomerState());

  Future<bool> createCustomer(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.createCustomer(data);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return CustomerNotifier(repository);
});
