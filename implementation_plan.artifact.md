# Implementation Plan: GSTIN Real-Time Validation & OTP Verification (VerifyOTP)

This plan outlines the implementation of instant GSTIN validation with auto-complete upon typing a valid GSTIN, strict regex validation for mobile number and GSTIN, and a dedicated **Verify OTP Page** (`VerifyOtpPage`) with modern UI styling, custom auto-submitting digit boxes, and Riverpod state management.

## User Review Required

> [!IMPORTANT]
> **Instant GSTIN Autocomplete & Verify OTP**:
> 1. **GSTIN Real-Time Validation**: As soon as a 15-character GSTIN is entered, the app instantly triggers the `/api/v1/gstin/verify` API and populates the company name.
> 2. **Mobile & GSTIN Validators**: Added strict regex validators for 10-digit mobile numbers and 15-character GSTIN format.
> 3. **Verify OTP Page**: A gorgeous modern OTP verification screen with 6-digit pin entry boxes that automatically validates upon complete entry.

## Proposed Changes

### 1. Validation & API Layer (`lib/features/auth/`)
- **[MODIFY] [validators.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/utils/validators.dart)**: Add `validateGstin` and `validateMobile`.
- **[MODIFY] [register_business_step.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/auth/presentation/widgets/register_business_step.dart)**: Add `onChanged` listener on GSTIN field to instantly trigger API validation when 15 chars are entered.

### 2. Verify OTP Page (`lib/features/auth/presentation/pages/`)
- **[NEW] [verify_otp_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/auth/presentation/pages/verify_otp_page.dart)**: Modern OTP verification screen with 6-digit PIN boxes and auto-submit.
- **[MODIFY] [app_router.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/router/app_router.dart)**: Add route for `/verify_otp`.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test typing a GSTIN and verifying instant autofill.
- Test Verify OTP page with auto-submit.
