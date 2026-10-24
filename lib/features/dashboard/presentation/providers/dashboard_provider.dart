import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data model for Income vs Expense metrics
class IncomeExpenseModel {
  final String period;
  final String profitMargin;
  final String totalIncome;
  final String totalExpense;
  final double incomeRatio; // 0..1 for bar width
  final double expenseRatio;

  const IncomeExpenseModel({
    required this.period,
    required this.profitMargin,
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeRatio,
    required this.expenseRatio,
  });
}

/// Data model for Overview 4-metric cards
class OverviewMetricItem {
  final String title;
  final String amount;
  final String count;
  final String trend;
  final bool isPositive;
  final List<double> sparklinePoints;

  const OverviewMetricItem({
    required this.title,
    required this.amount,
    required this.count,
    required this.trend,
    required this.isPositive,
    required this.sparklinePoints,
  });
}

/// Data model for Flow Chart Detail Box
class FlowDetailModel {
  final String periodLabel;
  final String profitBadge;
  final String saleAmount;
  final String purchaseAmount;
  final String creditNoteAmount;
  final String grossProfitAmount;

  const FlowDetailModel({
    required this.periodLabel,
    required this.profitBadge,
    required this.saleAmount,
    required this.purchaseAmount,
    required this.creditNoteAmount,
    required this.grossProfitAmount,
  });
}

/// Comprehensive State for Dashboard
class DashboardState {
  final String selectedFY;
  final String selectedIncomeExpensePeriod;
  final IncomeExpenseModel incomeExpenseData;
  final String selectedOverviewPeriod;
  final Map<String, OverviewMetricItem> overviewMetrics;
  final String selectedFlowRange;
  final FlowDetailModel flowDetail;
  final List<String> flowMonths;
  final List<double> flowSalePoints;
  final List<double> flowPurchasePoints;
  final List<double> flowCreditPoints;
  final String activeMenu;

  DashboardState({
    this.selectedFY = 'FY 2026-27',
    this.selectedIncomeExpensePeriod = 'This Month',
    required this.incomeExpenseData,
    this.selectedOverviewPeriod = 'This FY',
    required this.overviewMetrics,
    this.selectedFlowRange = '12M',
    required this.flowDetail,
    required this.flowMonths,
    required this.flowSalePoints,
    required this.flowPurchasePoints,
    required this.flowCreditPoints,
    this.activeMenu = 'Dashboard',
  });

  DashboardState copyWith({
    String? selectedFY,
    String? selectedIncomeExpensePeriod,
    IncomeExpenseModel? incomeExpenseData,
    String? selectedOverviewPeriod,
    Map<String, OverviewMetricItem>? overviewMetrics,
    String? selectedFlowRange,
    FlowDetailModel? flowDetail,
    List<String>? flowMonths,
    List<double>? flowSalePoints,
    List<double>? flowPurchasePoints,
    List<double>? flowCreditPoints,
    String? activeMenu,
  }) {
    return DashboardState(
      selectedFY: selectedFY ?? this.selectedFY,
      selectedIncomeExpensePeriod: selectedIncomeExpensePeriod ?? this.selectedIncomeExpensePeriod,
      incomeExpenseData: incomeExpenseData ?? this.incomeExpenseData,
      selectedOverviewPeriod: selectedOverviewPeriod ?? this.selectedOverviewPeriod,
      overviewMetrics: overviewMetrics ?? this.overviewMetrics,
      selectedFlowRange: selectedFlowRange ?? this.selectedFlowRange,
      flowDetail: flowDetail ?? this.flowDetail,
      flowMonths: flowMonths ?? this.flowMonths,
      flowSalePoints: flowSalePoints ?? this.flowSalePoints,
      flowPurchasePoints: flowPurchasePoints ?? this.flowPurchasePoints,
      flowCreditPoints: flowCreditPoints ?? this.flowCreditPoints,
      activeMenu: activeMenu ?? this.activeMenu,
    );
  }
}

/// Notifier providing reactive demo datasets for all dashboard dropdowns and filters
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(_initialState);

  static final DashboardState _initialState = DashboardState(
    selectedFY: 'FY 2026-27',
    selectedIncomeExpensePeriod: 'This Month',
    incomeExpenseData: const IncomeExpenseModel(
      period: 'This Month',
      profitMargin: '39.81%',
      totalIncome: '₹ 6,85,000.00',
      totalExpense: '₹ 4,12,300.00',
      incomeRatio: 1.0,
      expenseRatio: 0.60,
    ),
    selectedOverviewPeriod: 'This FY',
    overviewMetrics: {
      'tax': const OverviewMetricItem(
        title: 'Tax Invoices',
        amount: '₹2.98 Cr',
        count: '1,142 Invoices',
        trend: '12.8% vs last month',
        isPositive: true,
        sparklinePoints: [0.2, 0.4, 0.35, 0.7, 0.6, 0.85, 0.8],
      ),
      'eway': const OverviewMetricItem(
        title: 'E-Way Bills',
        amount: '₹1.86 Cr',
        count: '412 Bills',
        trend: '8.1% vs last month',
        isPositive: true,
        sparklinePoints: [0.15, 0.3, 0.5, 0.4, 0.65, 0.6, 0.75],
      ),
      'purchase': const OverviewMetricItem(
        title: 'Purchase\nInvoices',
        amount: '₹2.12 Cr',
        count: '806 Invoices',
        trend: '3.7% vs last month',
        isPositive: false,
        sparklinePoints: [0.5, 0.3, 0.45, 0.25, 0.4, 0.3, 0.2],
      ),
      'credit': const OverviewMetricItem(
        title: 'Credit Notes',
        amount: '₹11.84 L',
        count: '57 Notes',
        trend: '8.4% vs last month',
        isPositive: true,
        sparklinePoints: [0.2, 0.35, 0.3, 0.6, 0.5, 0.8, 0.75],
      ),
    },
    selectedFlowRange: '12M',
    flowDetail: const FlowDetailModel(
      periodLabel: 'Oct 2026',
      profitBadge: 'Profit 40.13%',
      saleAmount: '₹ 48,62,000.00',
      purchaseAmount: '₹ 29,47,000.00',
      creditNoteAmount: '₹ 1,84,000.00',
      grossProfitAmount: '₹ 19,51,000.00',
    ),
    flowMonths: const ['Dec', 'Feb', 'Apr', 'Jun', 'Aug', 'Oct'],
    flowSalePoints: const [0.45, 0.40, 0.65, 0.60, 0.75, 0.90],
    flowPurchasePoints: const [0.25, 0.35, 0.32, 0.48, 0.42, 0.55],
    flowCreditPoints: const [0.08, 0.10, 0.09, 0.12, 0.11, 0.10],
  );

  /// Change Financial Year Dropdown
  void setFY(String fy) {
    if (fy == 'FY 2025-26') {
      state = state.copyWith(
        selectedFY: fy,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'This Month',
          profitMargin: '36.40%',
          totalIncome: '₹ 5,90,000.00',
          totalExpense: '₹ 3,75,000.00',
          incomeRatio: 0.85,
          expenseRatio: 0.55,
        ),
        overviewMetrics: {
          'tax': const OverviewMetricItem(
            title: 'Tax Invoices',
            amount: '₹2.45 Cr',
            count: '984 Invoices',
            trend: '10.2% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.3, 0.45, 0.4, 0.6, 0.55, 0.75, 0.7],
          ),
          'eway': const OverviewMetricItem(
            title: 'E-Way Bills',
            amount: '₹1.50 Cr',
            count: '365 Bills',
            trend: '7.5% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.2, 0.35, 0.4, 0.5, 0.55, 0.6, 0.65],
          ),
          'purchase': const OverviewMetricItem(
            title: 'Purchase\nInvoices',
            amount: '₹1.80 Cr',
            count: '720 Invoices',
            trend: '4.2% vs prev FY',
            isPositive: false,
            sparklinePoints: [0.4, 0.35, 0.4, 0.3, 0.35, 0.3, 0.25],
          ),
          'credit': const OverviewMetricItem(
            title: 'Credit Notes',
            amount: '₹9.60 L',
            count: '48 Notes',
            trend: '6.8% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.15, 0.25, 0.3, 0.45, 0.5, 0.6, 0.55],
          ),
        },
      );
    } else if (fy == 'FY 2024-25') {
      state = state.copyWith(
        selectedFY: fy,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'This Month',
          profitMargin: '34.10%',
          totalIncome: '₹ 4,80,000.00',
          totalExpense: '₹ 3,16,000.00',
          incomeRatio: 0.70,
          expenseRatio: 0.46,
        ),
        overviewMetrics: {
          'tax': const OverviewMetricItem(
            title: 'Tax Invoices',
            amount: '₹1.95 Cr',
            count: '780 Invoices',
            trend: '8.4% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.25, 0.35, 0.4, 0.5, 0.6, 0.65, 0.6],
          ),
          'eway': const OverviewMetricItem(
            title: 'E-Way Bills',
            amount: '₹1.20 Cr',
            count: '290 Bills',
            trend: '5.8% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.15, 0.25, 0.3, 0.4, 0.45, 0.5, 0.55],
          ),
          'purchase': const OverviewMetricItem(
            title: 'Purchase\nInvoices',
            amount: '₹1.45 Cr',
            count: '590 Invoices',
            trend: '2.9% vs prev FY',
            isPositive: false,
            sparklinePoints: [0.35, 0.3, 0.35, 0.25, 0.3, 0.25, 0.2],
          ),
          'credit': const OverviewMetricItem(
            title: 'Credit Notes',
            amount: '₹7.20 L',
            count: '36 Notes',
            trend: '5.1% vs prev FY',
            isPositive: true,
            sparklinePoints: [0.1, 0.2, 0.25, 0.35, 0.4, 0.45, 0.4],
          ),
        },
      );
    } else {
      // Default FY 2026-27
      state = state.copyWith(
        selectedFY: fy,
        incomeExpenseData: _initialState.incomeExpenseData,
        overviewMetrics: _initialState.overviewMetrics,
      );
    }
  }

  /// Change Income vs Expense Period Dropdown
  void setIncomeExpensePeriod(String period) {
    if (period == 'Last Month') {
      state = state.copyWith(
        selectedIncomeExpensePeriod: period,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'Last Month',
          profitMargin: '42.15%',
          totalIncome: '₹ 7,40,000.00',
          totalExpense: '₹ 4,28,000.00',
          incomeRatio: 1.0,
          expenseRatio: 0.58,
        ),
      );
    } else if (period == 'This Quarter') {
      state = state.copyWith(
        selectedIncomeExpensePeriod: period,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'This Quarter',
          profitMargin: '38.45%',
          totalIncome: '₹ 21,50,000.00',
          totalExpense: '₹ 13,24,000.00',
          incomeRatio: 1.0,
          expenseRatio: 0.62,
        ),
      );
    } else if (period == 'This Financial Year') {
      state = state.copyWith(
        selectedIncomeExpensePeriod: period,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'This Financial Year',
          profitMargin: '40.50%',
          totalIncome: '₹ 84,20,000.00',
          totalExpense: '₹ 50,10,000.00',
          incomeRatio: 1.0,
          expenseRatio: 0.59,
        ),
      );
    } else {
      // This Month
      state = state.copyWith(
        selectedIncomeExpensePeriod: period,
        incomeExpenseData: const IncomeExpenseModel(
          period: 'This Month',
          profitMargin: '39.81%',
          totalIncome: '₹ 6,85,000.00',
          totalExpense: '₹ 4,12,300.00',
          incomeRatio: 1.0,
          expenseRatio: 0.60,
        ),
      );
    }
  }

  /// Change Overview Period Dropdown
  void setOverviewPeriod(String period) {
    if (period == 'This Quarter') {
      state = state.copyWith(
        selectedOverviewPeriod: period,
        overviewMetrics: {
          'tax': const OverviewMetricItem(
            title: 'Tax Invoices',
            amount: '₹82.40 L',
            count: '320 Invoices',
            trend: '9.4% vs last qtr',
            isPositive: true,
            sparklinePoints: [0.3, 0.5, 0.4, 0.7, 0.65, 0.8, 0.75],
          ),
          'eway': const OverviewMetricItem(
            title: 'E-Way Bills',
            amount: '₹54.10 L',
            count: '115 Bills',
            trend: '6.2% vs last qtr',
            isPositive: true,
            sparklinePoints: [0.2, 0.4, 0.45, 0.5, 0.6, 0.65, 0.7],
          ),
          'purchase': const OverviewMetricItem(
            title: 'Purchase\nInvoices',
            amount: '₹59.80 L',
            count: '210 Invoices',
            trend: '2.1% vs last qtr',
            isPositive: false,
            sparklinePoints: [0.45, 0.35, 0.4, 0.3, 0.35, 0.25, 0.2],
          ),
          'credit': const OverviewMetricItem(
            title: 'Credit Notes',
            amount: '₹3.45 L',
            count: '18 Notes',
            trend: '5.5% vs last qtr',
            isPositive: true,
            sparklinePoints: [0.15, 0.3, 0.35, 0.5, 0.55, 0.7, 0.65],
          ),
        },
      );
    } else if (period == 'This Month') {
      state = state.copyWith(
        selectedOverviewPeriod: period,
        overviewMetrics: {
          'tax': const OverviewMetricItem(
            title: 'Tax Invoices',
            amount: '₹28.50 L',
            count: '105 Invoices',
            trend: '14.2% vs last mo',
            isPositive: true,
            sparklinePoints: [0.15, 0.35, 0.3, 0.65, 0.6, 0.8, 0.85],
          ),
          'eway': const OverviewMetricItem(
            title: 'E-Way Bills',
            amount: '₹18.20 L',
            count: '42 Bills',
            trend: '11.0% vs last mo',
            isPositive: true,
            sparklinePoints: [0.1, 0.25, 0.4, 0.35, 0.6, 0.55, 0.7],
          ),
          'purchase': const OverviewMetricItem(
            title: 'Purchase\nInvoices',
            amount: '₹20.10 L',
            count: '74 Invoices',
            trend: '4.5% vs last mo',
            isPositive: false,
            sparklinePoints: [0.5, 0.3, 0.4, 0.25, 0.35, 0.25, 0.15],
          ),
          'credit': const OverviewMetricItem(
            title: 'Credit Notes',
            amount: '₹1.20 L',
            count: '6 Notes',
            trend: '12.0% vs last mo',
            isPositive: true,
            sparklinePoints: [0.2, 0.3, 0.35, 0.55, 0.5, 0.75, 0.7],
          ),
        },
      );
    } else if (period == 'Last FY') {
      state = state.copyWith(
        selectedOverviewPeriod: period,
        overviewMetrics: {
          'tax': const OverviewMetricItem(
            title: 'Tax Invoices',
            amount: '₹2.45 Cr',
            count: '980 Invoices',
            trend: '18.5% growth',
            isPositive: true,
            sparklinePoints: [0.2, 0.35, 0.4, 0.55, 0.5, 0.7, 0.65],
          ),
          'eway': const OverviewMetricItem(
            title: 'E-Way Bills',
            amount: '₹1.52 Cr',
            count: '360 Bills',
            trend: '12.4% growth',
            isPositive: true,
            sparklinePoints: [0.15, 0.25, 0.35, 0.45, 0.5, 0.55, 0.6],
          ),
          'purchase': const OverviewMetricItem(
            title: 'Purchase\nInvoices',
            amount: '₹1.85 Cr',
            count: '710 Invoices',
            trend: '5.8% increase',
            isPositive: false,
            sparklinePoints: [0.4, 0.35, 0.4, 0.3, 0.35, 0.3, 0.25],
          ),
          'credit': const OverviewMetricItem(
            title: 'Credit Notes',
            amount: '₹9.50 L',
            count: '48 Notes',
            trend: '9.1% growth',
            isPositive: true,
            sparklinePoints: [0.1, 0.2, 0.3, 0.4, 0.45, 0.55, 0.5],
          ),
        },
      );
    } else {
      // This FY
      state = state.copyWith(
        selectedOverviewPeriod: period,
        overviewMetrics: _initialState.overviewMetrics,
      );
    }
  }

  /// Change Flow Range (12M, 6M, 3M, 7D)
  void setFlowRange(String range) {
    if (range == '6M') {
      state = state.copyWith(
        selectedFlowRange: range,
        flowMonths: const ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
        flowSalePoints: const [0.55, 0.50, 0.68, 0.72, 0.80, 0.92],
        flowPurchasePoints: const [0.35, 0.42, 0.38, 0.45, 0.48, 0.56],
        flowCreditPoints: const [0.10, 0.12, 0.08, 0.11, 0.10, 0.09],
        flowDetail: const FlowDetailModel(
          periodLabel: 'Last 6 Months',
          profitBadge: 'Profit 41.50%',
          saleAmount: '₹ 28,40,000.00',
          purchaseAmount: '₹ 16,60,000.00',
          creditNoteAmount: '₹ 95,000.00',
          grossProfitAmount: '₹ 11,80,000.00',
        ),
      );
    } else if (range == '3M') {
      state = state.copyWith(
        selectedFlowRange: range,
        flowMonths: const ['Aug', 'Sep', 'Oct'],
        flowSalePoints: const [0.60, 0.75, 0.90],
        flowPurchasePoints: const [0.40, 0.48, 0.55],
        flowCreditPoints: const [0.09, 0.12, 0.10],
        flowDetail: const FlowDetailModel(
          periodLabel: 'Last 3 Months',
          profitBadge: 'Profit 38.90%',
          saleAmount: '₹ 14,80,000.00',
          purchaseAmount: '₹ 9,05,000.00',
          creditNoteAmount: '₹ 52,000.00',
          grossProfitAmount: '₹ 5,75,000.00',
        ),
      );
    } else if (range == '7D') {
      state = state.copyWith(
        selectedFlowRange: range,
        flowMonths: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        flowSalePoints: const [0.35, 0.50, 0.45, 0.70, 0.85, 0.65, 0.78],
        flowPurchasePoints: const [0.20, 0.32, 0.28, 0.42, 0.50, 0.38, 0.45],
        flowCreditPoints: const [0.05, 0.08, 0.04, 0.09, 0.06, 0.07, 0.05],
        flowDetail: const FlowDetailModel(
          periodLabel: 'Past 7 Days',
          profitBadge: 'Profit 43.20%',
          saleAmount: '₹ 3,45,000.00',
          purchaseAmount: '₹ 1,95,000.00',
          creditNoteAmount: '₹ 12,500.00',
          grossProfitAmount: '₹ 1,50,000.00',
        ),
      );
    } else {
      // 12M
      state = state.copyWith(
        selectedFlowRange: range,
        flowMonths: _initialState.flowMonths,
        flowSalePoints: _initialState.flowSalePoints,
        flowPurchasePoints: _initialState.flowPurchasePoints,
        flowCreditPoints: _initialState.flowCreditPoints,
        flowDetail: _initialState.flowDetail,
      );
    }
  }

  void setActiveMenu(String menu) {
    state = state.copyWith(activeMenu: menu);
  }
}

final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
