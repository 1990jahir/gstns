# Implementation Plan: Trading, Profit & Loss Reports Page

This plan outlines the creation of a modern, mobile-optimized Reports module (`ReportsPage`) mirroring the Trading, Profit & Loss Report web view, complete with date range filters, "Download Report" action, and structured debit/credit financial breakdowns using Riverpod state management.

## User Review Required

> [!IMPORTANT]
> **Profit & Loss Structure**: The report will display financial statements divided into debit (Expenses, Opening Stock, Purchases) and credit (Sales, Closing Stock, Incomes) sections, optimized for mobile cards with a "Download Report" action and date filtering.

## Proposed Changes

### 1. Reports Module (`lib/features/reports/`)
- **[NEW] [reports_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/reports/presentation/pages/reports_page.dart)**: Modern mobile Reports screen with date range filters, Download Report button, and accordion/card financial sections for Profit & Loss.
- **[NEW] [reports_provider.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/reports/presentation/providers/reports_provider.dart)**: Riverpod state provider managing P&L data and date filter states.

### 2. Navigation Integration (`lib/core/router/app_router.dart` & `MainDashboardLayout`)
- **[MODIFY] [app_router.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/router/app_router.dart)**: Add route for `/reports`.
- **[MODIFY] [main_dashboard_layout.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/pages/main_dashboard_layout.dart)**: Wire up the bottom navbar "Reports" tab to `ReportsPage`.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test date filtering and Download Report action.
- Verify mobile card layout of Profit & Loss particulars.
