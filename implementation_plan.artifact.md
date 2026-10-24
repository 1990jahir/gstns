# Implementation Plan: Global Shared Input Field (`GlobalInputField`)

This plan outlines the extraction of the professional floating label input field into a global shared component (`GlobalInputField`) located in `lib/core/widgets/global_input_field.dart`, and replacing feature-specific text inputs across the app with this unified global component.

## User Review Required

> [!IMPORTANT]
> **Global Input Field**: We will move `FloatingLabelInput` into `lib/core/widgets/global_input_field.dart` as `GlobalInputField`, ensuring consistent floating animations, fixed 56px height, and validation styling across all pages (Login, Register, Add Customer, Invoices, Settings).

## Proposed Changes

### 1. Global Widgets (`lib/core/widgets/`)
- **[NEW] [global_input_field.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/widgets/global_input_field.dart)**: Unified global input field widget with floating label support, custom formatters (`UpperCaseTextFormatter`), and validation states.
- **[MODIFY] Existing pages/widgets**: Adopt `GlobalInputField` where appropriate.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test input typing and floating label animation across login/register/customer forms.
