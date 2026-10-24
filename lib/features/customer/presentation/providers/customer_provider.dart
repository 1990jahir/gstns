import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/customer_repository.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository());

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
