# Implementation Plan: Invoices Section with Two Tabs (Purchase & Incoming Invoices)

This plan outlines the creation of a modern, mobile-optimized Invoices module featuring **two tabs** (`Purchase Invoice` and `Incoming Invoice`), matching the clean card-based design of the Customer section and the web reference screenshots.

## User Review Required

> [!IMPORTANT]
> **Two-Tab Structure**: The Invoices screen will feature a sleek top tab bar allowing users to seamlessly switch between **Purchase Invoices** and **Incoming Invoices**.
> **Create Invoice & Card Views**: Each invoice type will display professional mobile cards with Status badges, Invoice No, Date, EWB No, Company Name, Taxable Amount, and Total Amount, along with an "Add / Create Invoice" form.

## Proposed Changes

### 1. Invoices Module (`lib/features/invoice/`)
- **[NEW] [invoices_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/invoice/presentation/pages/invoices_page.dart)**: Two-tab container page hosting `PurchaseInvoicesTab` and `IncomingInvoicesTab`.
- **[NEW] [purchase_invoices_tab.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/invoice/presentation/widgets/purchase_invoices_tab.dart)**: Purchase invoice list cards, search, date filters, and `+` create invoice button.
- **[NEW] [incoming_invoices_tab.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/invoice/presentation/widgets/incoming_invoices_tab.dart)**: Incoming invoice list cards, search, and filters.
- **[NEW] [create_invoice_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/invoice/presentation/pages/create_invoice_page.dart)**: Create invoice form mirroring the web reference ("Supply Type", "Vendor Name", "Item Details", "Invoice Summary", "Transportation Details", "Part B").

### 2. Navigation Integration (`lib/core/router/app_router.dart` & `MainDashboardLayout`)
- **[MODIFY] [app_router.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/router/app_router.dart)**: Add routes for `/invoices` and `/create_invoice`.
- **[MODIFY] [main_dashboard_layout.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/pages/main_dashboard_layout.dart)**: Wire up the bottom navbar "Invoices" tab to `InvoicesPage`.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test switching between Purchase Invoice and Incoming Invoice tabs.
- Verify Create Invoice form and search functionality.
