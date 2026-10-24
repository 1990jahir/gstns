# Implementation Plan: PDF-Exact Dashboard & Navbar Redesign

This plan outlines the exact recreation of the dashboard and bottom navigation bar to match the reference screenshot from `B · Money-first Header.pdf`, incorporating the income vs. expense summary card, 4-grid overview metrics, quick action icons, import banner, period filter pills (`12M`, `6M`, `3M`, `7D`), and the 5-tab bottom navbar (Home, Invoices, [+], Purchase, More).

## User Review Required

> [!IMPORTANT]
> **PDF-Exact Dashboard & Navbar Alignment**:
> 1. **Bottom Navbar**: 5 tabs matching the reference (`Home`, `Invoices`, `[+]`, `Purchase`, `More`).
> 2. **Income vs Expense Card**: Profit margin, total income, and total expense summary.
> 3. **Overview Metrics Grid**: 4 cards with exact values (`₹2.98 Cr`, `₹1.86 Cr`, `₹2.12 Cr`, `₹11.84 L`).
> 4. **Flow Chart Period Pills**: `12M`, `6M`, `3M`, `7D` selectors.

## Proposed Changes

### 1. Dashboard & Navbar Module (`lib/features/dashboard/`)
- **[MODIFY] [modern_bottom_nav_bar.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart)**: Update bottom navbar to have the exact 5 tabs (`Home`, `Invoices`, `[+]`, `Purchase`, `More`).
- **[MODIFY] [dashboard_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/pages/dashboard_page.dart)**: Revamp layout to match the reference screenshot (Income vs Expense card, Overview grid, Quick Actions, Flow Chart with period pills, Recent Activity).

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test bottom navbar tabs and dashboard layout against the PDF reference screenshot.
