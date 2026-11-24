# Implementation Plan: Feature-Based Modular Refactoring (Inventory, E-Way Bill, E-Invoice, GSTR Filing)

This plan outlines the complete restructuring of the newly added features (`inventory`, `eway_bill`, `einvoice`, `gstr_filing`) to adhere strictly to our feature-based modular architecture and coding standards (`CODING_STANDARD.md`), including decoupled widgets and Riverpod state notifiers for each module.

## User Review Required

> [!IMPORTANT]
> **Modular Refactoring**: Every feature will now have a dedicated `providers/` and `widgets/` folder with proper state management and decoupled UI components.

## Proposed Changes

### 1. Feature Modules Refactoring (`lib/features/`)
- **[NEW] Inventory Module (`lib/features/inventory/`)**: `inventory_provider.dart`, `inventory_item_card.dart`, `inventory_items_page.dart`.
- **[NEW] E-Way Bill Module (`lib/features/eway_bill/`)**: `eway_bill_provider.dart`, `eway_bill_card.dart`, `eway_bills_page.dart`.
- **[NEW] E-Invoice Module (`lib/features/einvoice/`)**: `einvoice_provider.dart`, `einvoice_card.dart`, `einvoices_page.dart`.
- **[NEW] GSTR Filing Module (`lib/features/gstr_filing/`)**: `gstr_filing_provider.dart`, `gstr_filing_card.dart`, `gstr_filing_page.dart`.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.
