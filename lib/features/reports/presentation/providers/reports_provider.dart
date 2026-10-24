import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/string_manager.dart';

class ReportsState {
  final String startDate;
  final String endDate;
  final bool isLoading;

  ReportsState({
    this.startDate = StringManager.defaultStartDate,
    this.endDate = StringManager.defaultEndDate,
    this.isLoading = false,
  });

  ReportsState copyWith({
    String? startDate,
    String? endDate,
    bool? isLoading,
  }) {
    return ReportsState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(ReportsState());

  void setDateRange(String start, String end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final reportsNotifierProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier();
});
