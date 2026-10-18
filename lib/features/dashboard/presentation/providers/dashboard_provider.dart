import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for Dashboard filters, date ranges, and active navigation menu.
class DashboardState {
  final String selectedDateRange;
  final String selectedGraphFilter;
  final String activeMenu;

  DashboardState({
    this.selectedDateRange = 'Select a range',
    this.selectedGraphFilter = 'Last 12 Months',
    this.activeMenu = 'Dashboard',
  });

  DashboardState copyWith({
    String? selectedDateRange,
    String? selectedGraphFilter,
    String? activeMenu,
  }) {
    return DashboardState(
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedGraphFilter: selectedGraphFilter ?? this.selectedGraphFilter,
      activeMenu: activeMenu ?? this.activeMenu,
    );
  }
}

/// Notifier to manage dashboard state updates.
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState());

  void setDateRange(String range) {
    state = state.copyWith(selectedDateRange: range);
  }

  void setGraphFilter(String filter) {
    state = state.copyWith(selectedGraphFilter: filter);
  }

  void setActiveMenu(String menu) {
    state = state.copyWith(activeMenu: menu);
  }
}

final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
