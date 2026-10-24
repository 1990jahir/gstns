# Project Progress & Development Log

This document maintains a chronological record of all features, architecture updates, architectural components, and UI implementations added to the project.

---

## 🚀 Commit Log & Development History

### [COMMIT #001] to [COMMIT #054] - Core Architecture, Auth, Dashboard, API Integration, Global Loader, Caching, Floating Navbar, Menu Sheet, Navbar Profile Integration, Modern Profile Redesign, Menu Accordions, Dashboard Sparklines, Card Shadows, Title Removal, Divider Cleanup, Drivvo Menu Redesign, Apple Health Cards, Splash, Onboarding, Unified Buttons, Modern Register, Google/WhatsApp Assets, Full-Screen Onboarding, Menu Features Alignment, Full-Screen Onboarding Cards, Modern Login/Register Redesign, Customers Module, Add Customer Navigation Link, StringManager Centralization, Android Manifest Permissions, Trading, Profit & Loss Reports Module, CODING_STANDARD.md, AI-Era Profile Settings, Register API Integration, Corrected Basic Auth Token, Company Settings Page, Invoice Settings Page, Profile Settings Navigation, Section Repositioning, Company Settings Overflow Fix, Theme-Colored Shadows, Validators StringManager Centralization, Register Challenge Fix, GSTIN API Error Handling, Session Persistence, Money-First Header Dashboard, PDF-Exact Dashboard Navbar Alignment & Inter Font Style Consistency
- **What Was Done:** Established feature-based modular structure, Light/Dark themes, Inter typography, Login/Register pages, Repository & Data sources, API interceptors, Global Loader, Caching, Android configuration, modern SliverAppBar Dashboard, Navbar menu sheet, Basic Auth alignment, SharedPreferences initialization, floating animated bottom navigation bar, profile navbar integration, modern profile page redesign, expandable menu accordions with sub-menus, sparkline metric cards, prominent card shadows with gradients, title removal, divider cleanup, Drivvo-inspired menu redesign, Apple Health widget cards, splash screen, onboarding story view, unified custom button styling, onboarding paginator view, modern register page, custom asset icons, full-screen onboarding, menu feature alignment, full-screen onboarding cards layout, modern login/register card redesign, customers module, add customer page, customer navigation wiring, string centralization, manifest permissions, trading, profit & loss reports module, coding standard guide, AI-era profile settings, register API integration, corrected Basic Auth token, company settings page, invoice settings page, profile settings navigation, section repositioning, company settings overflow fix, theme-colored shadows, validator string centralization, register challenge fix, GSTIN error handling, session persistence, money-first header dashboard, PDF-exact dashboard navbar alignment, and Inter font style consistency.

---

### [COMMIT #055] - GlobalInputField Enhancement with Prefix Icon & Full Dark Theme Support
- **Date & Time:** February 25, 2026 | 11:45 PM
- **FeatureName:** `global-input-field-prefix-icon-dark-theme`
- **Git Additions:**
  - `lib/core/widgets/global_input_field.dart`
- **What Was Done:**
  - Enhanced `GlobalInputField` to natively support prefix icons (`prefixIcon`), dynamic text positioning, and full dark theme support (`ColorManager.darkCardSurface`, `darkBorderColor`, `darkTextPrimary`, etc.).
  - Verified static analysis (`flutter analyze`) and test suite (`flutter test`) passing with zero errors or warnings.---

### [COMMIT #060] - Prevent Redundant Token Refresh & 401 on Logout
- **Date & Time:** October 24, 2026 | 11:00 PM
- **Feature Name:** `logout-debounce-and-safe-termination`
- **Git Additions & Updates:**
  - `lib/core/network/interceptors/auth_interceptor.dart`
  - `lib/features/auth/data/datasources/auth_remote_data_source.dart`
  - `lib/features/auth/domain/repositories/auth_repository.dart`
  - `lib/features/auth/presentation/providers/auth_provider.dart`
  - `android/app/src/main/AndroidManifest.xml`
- **What Was Done:**
  - **Diagnosed 401 on Logout**: Traced user error report where `/api/v1/auth/logout` was called twice: the first call refreshed the expired token and succeeded with 200, while a rapid second tap/dispatch sent `AUTH: null` because tokens were already cleared in memory, causing a 401 Unauthorized rejection.
  - **No Refresh on Logout**: Configured `AuthInterceptor.onError` to explicitly skip token refresh if the path is `/api/v1/auth/logout`, immediately resolving locally since the session is already terminated.
  - **Logout Reentrancy Guard**: Added `_isLoggingOut` and `isLoading` debounce locks in `AuthRepository` and `AuthNotifier` to prevent multiple concurrent or duplicate logout network calls.
  - **Token Null Guard**: Verified that `/api/v1/auth/logout` is only called when an active `accessToken` is present in memory.
  - **Benign 401 Handling**: Added `validateStatus: (status) => status != null && status < 500` to `AuthRemoteDataSource.logout()` so expired sessions do not throw unhandled Dio exceptions during logout.
  - **Android Warning Fix**: Added `android:enableOnBackInvokedCallback="true"` to `AndroidManifest.xml` to eliminate Android predictive back navigation warning.
---

### [COMMIT #056] - Universal Adoption of GlobalInputField Across All Modules
- **Date & Time:** October 24, 2026 | 09:15 PM
- **Feature Name:** `universal-global-input-field-integration`
- **Git Additions & Updates:**
  - `lib/core/widgets/global_input_field.dart`
  - `lib/core/widgets/custom_text_field.dart`
  - `lib/features/auth/presentation/widgets/login_input_field.dart`
  - `lib/features/auth/presentation/widgets/auth_text_field.dart`
  - `lib/features/auth/presentation/widgets/floating_label_input.dart`
  - `lib/features/auth/presentation/widgets/register_business_pane.dart`
  - `lib/features/auth/presentation/widgets/register_security_pane.dart`
- **What Was Done:**
  - **Form Validation Support**: Added `FormFieldValidator<String>? validator` and `hintText` integration to `GlobalInputField`, allowing it to seamlessly validate with standard Flutter `FormKey.currentState.validate()`.
  - **CustomTextField Unified**: Rewrote `CustomTextField` to delegate directly to `GlobalInputField`. This automatically propagates `GlobalInputField` to `AddCustomerPage`, `CompanySettingsForm`, `ProfileSettingsForm`, `InvoiceSettingsForm`, and `CreateInvoicePage`.
  - **LoginInputField Unified**: Rewrote `LoginInputField` to delegate to `GlobalInputField`, upgrading the Login flow with floating labels, prefix icons, and theme green focus rings.
  - **AuthTextField Unified**: Updated `AuthTextField` to utilize `GlobalInputField`.
  - **Register Panes Unified**: Replaced all local input references in `RegisterBusinessPane` and `RegisterSecurityPane` with `GlobalInputField`.
  - **Backward Compatibility**: Re-exported `GlobalInputField` in `floating_label_input.dart` with a typedef alias to guarantee zero breaking changes across existing references or tests.---

### [COMMIT #060] - Prevent Redundant Token Refresh & 401 on Logout
- **Date & Time:** October 24, 2026 | 11:00 PM
- **Feature Name:** `logout-debounce-and-safe-termination`
- **Git Additions & Updates:**
  - `lib/core/network/interceptors/auth_interceptor.dart`
  - `lib/features/auth/data/datasources/auth_remote_data_source.dart`
  - `lib/features/auth/domain/repositories/auth_repository.dart`
  - `lib/features/auth/presentation/providers/auth_provider.dart`
  - `android/app/src/main/AndroidManifest.xml`
- **What Was Done:**
  - **Diagnosed 401 on Logout**: Traced user error report where `/api/v1/auth/logout` was called twice: the first call refreshed the expired token and succeeded with 200, while a rapid second tap/dispatch sent `AUTH: null` because tokens were already cleared in memory, causing a 401 Unauthorized rejection.
  - **No Refresh on Logout**: Configured `AuthInterceptor.onError` to explicitly skip token refresh if the path is `/api/v1/auth/logout`, immediately resolving locally since the session is already terminated.
  - **Logout Reentrancy Guard**: Added `_isLoggingOut` and `isLoading` debounce locks in `AuthRepository` and `AuthNotifier` to prevent multiple concurrent or duplicate logout network calls.
  - **Token Null Guard**: Verified that `/api/v1/auth/logout` is only called when an active `accessToken` is present in memory.
  - **Benign 401 Handling**: Added `validateStatus: (status) => status != null && status < 500` to `AuthRemoteDataSource.logout()` so expired sessions do not throw unhandled Dio exceptions during logout.
  - **Android Warning Fix**: Added `android:enableOnBackInvokedCallback="true"` to `AndroidManifest.xml` to eliminate Android predictive back navigation warning.
---

### [COMMIT #056] - Universal Adoption of GlobalInputField Across All Modules
- **Date & Time:** October 24, 2026 | 09:15 PM
- **Feature Name:** `universal-global-input-field-integration`
- **Git Additions & Updates:**
  - `lib/core/widgets/global_input_field.dart`
  - `lib/core/widgets/custom_text_field.dart`
  - `lib/features/auth/presentation/widgets/login_input_field.dart`
  - `lib/features/auth/presentation/widgets/auth_text_field.dart`
  - `lib/features/auth/presentation/widgets/floating_label_input.dart`
  - `lib/features/auth/presentation/widgets/register_business_pane.dart`
  - `lib/features/auth/presentation/widgets/register_security_pane.dart`
- **What Was Done:**
  - **Form Validation Support**: Added `FormFieldValidator<String>? validator` and `hintText` integration to `GlobalInputField`, allowing it to seamlessly validate with standard Flutter `FormKey.currentState.validate()`.
  - **CustomTextField Unified**: Rewrote `CustomTextField` to delegate directly to `GlobalInputField`. This automatically propagates `GlobalInputField` to `AddCustomerPage`, `CompanySettingsForm`, `ProfileSettingsForm`, `InvoiceSettingsForm`, and `CreateInvoicePage`.
  - **LoginInputField Unified**: Rewrote `LoginInputField` to delegate to `GlobalInputField`, upgrading the Login flow with floating labels, prefix icons, and theme green focus rings.
  - **AuthTextField Unified**: Updated `AuthTextField` to utilize `GlobalInputField`.
  - **Register Panes Unified**: Replaced all local input references in `RegisterBusinessPane` and `RegisterSecurityPane` with `GlobalInputField`.
  - **Backward Compatibility**: Re-exported `GlobalInputField` in `floating_label_input.dart` with a typedef alias to guarantee zero breaking changes across existing references or tests.---

### [COMMIT #057] - Complete Feature-by-Feature Replacement with GlobalInputField
- **Date & Time:** October 24, 2026 | 09:25 PM
- **Feature Name:** `feature-wise-global-input-field-adoption`
- **Git Additions & Updates:**
  - `lib/core/widgets/global_input_field.dart`
  - `lib/features/auth/presentation/pages/login_page.dart`
  - `lib/features/auth/presentation/pages/register_page.dart`
  - `lib/features/auth/presentation/widgets/register_business_pane.dart`
  - `lib/features/auth/presentation/widgets/register_security_pane.dart`
  - `lib/features/auth/presentation/widgets/register_business_step.dart`
  - `lib/features/auth/presentation/widgets/register_personal_step.dart`
  - `lib/features/customer/presentation/pages/customers_page.dart`
  - `lib/features/customer/presentation/pages/add_customer_page.dart`
  - `lib/features/invoice/presentation/pages/create_invoice_page.dart`
  - `lib/features/invoice/presentation/widgets/incoming_invoices_tab.dart`
  - `lib/features/invoice/presentation/widgets/purchase_invoices_tab.dart`
  - `lib/features/profile/presentation/widgets/company_settings_form.dart`
  - `lib/features/profile/presentation/widgets/invoice_settings_form.dart`
  - `lib/features/profile/presentation/widgets/profile_settings_form.dart`
  - `lib/features/reports/presentation/widgets/report_filter_card.dart`
- **What Was Done:**
  - **Auth Feature**: Replaced all login and register input fields with `GlobalInputField` directly across `login_page.dart`, `register_business_pane.dart`, `register_security_pane.dart`, `register_business_step.dart`, and `register_personal_step.dart`.
  - **Customer Feature**: Replaced search bar in `customers_page.dart` and all 15 customer creation inputs in `add_customer_page.dart` with `GlobalInputField`.
  - **Invoice Feature**: Replaced search bars in `incoming_invoices_tab.dart` and `purchase_invoices_tab.dart`, plus all invoice creation form inputs in `create_invoice_page.dart`, with `GlobalInputField`.
  - **Profile Feature**: Replaced all form fields across `company_settings_form.dart`, `invoice_settings_form.dart`, and `profile_settings_form.dart` (including the mobile field with its integrated change action) with `GlobalInputField`.
  - **Reports Feature**: Replaced start date and end date range filter inputs in `report_filter_card.dart` with `GlobalInputField`.
  - **Controller Flexibility**: Made `controller` optional in `GlobalInputField` so standalone search bars can automatically manage their internal text controllers.

---

### [COMMIT #058] - Fix Input Box Grey Selection & Background Fill Inheritance
- **Date & Time:** October 24, 2026 | 09:40 PM
- **Feature Name:** `fix-input-field-grey-background-and-selection`
- **Git Additions & Updates:**
  - `lib/core/widgets/global_input_field.dart`
  - `lib/core/theme/app_theme.dart`
- **What Was Done:**
  - **Root Cause**: Flutter's `InputDecorator` was inheriting `filled: true` and `fillColor: ColorManager.lightCard` (grey) from `AppTheme.inputDecorationTheme`. When an input had text or became focused ("selected"), Flutter's `InputDecorator` painted an inner grey fill/focus tint behind the text inside the white container.
  - **Transparent Fill Enforcement**: Configured `GlobalInputField`'s inner `TextField` with `filled: false`, `fillColor: Colors.transparent`, `focusColor: Colors.transparent`, and `hoverColor: Colors.transparent` across all border states.
  - **Custom Theme Wrapper**: Wrapped the inner `TextField` with an isolated `Theme` override guaranteeing that `inputDecorationTheme` defaults cannot inject grey fill or focus color.
  - **Themed Text Selection**: Configured `textSelectionTheme` with `ColorManager.primaryGreen` cursor, handle, and a 20% brand tint selection background (`brandColor.withValues(alpha: 0.20)`), ensuring any selected text uses the primary green brand theme instead of grey.
  - **Custom Background Color Support**: Wired `surfaceBg = widget.backgroundColor ?? widget.fillColor ?? (isDark ? ColorManager.darkCardSurface : Colors.white)`.

---

### [COMMIT #059] - Robust Session Management, Concurrency-Safe 401 Auto-Refresh, and Atomic Logout
- **Date & Time:** October 24, 2026 | 10:45 PM
- **Feature Name:** `session-management-auto-refresh-and-logout`
- **Git Additions & Updates:**
  - `lib/core/services/cache_service.dart`
  - `lib/core/network/interceptors/auth_interceptor.dart`
  - `lib/features/auth/domain/repositories/auth_repository.dart`
  - `lib/features/auth/presentation/providers/auth_provider.dart`
  - `lib/features/dashboard/presentation/widgets/menu_bottom_sheet.dart`
  - `lib/features/dashboard/presentation/widgets/profile_modal.dart`
  - `lib/features/profile/presentation/widgets/profile_actions.dart`
  - `lib/features/auth/presentation/pages/splash_page.dart`
- **What Was Done:**
  - **Identified Gaps**: Diagnosed ghost auto-login on app restart (caused by uncalled cache eviction), leaked in-memory tokens, missing in-memory token initialization after login/registration, concurrency race conditions during parallel 401 responses, and missing session expiry redirects.
  - **Storage Layer**: Added `updateTokens({required String accessToken, required String refreshToken})` to `CacheService` for atomic token updates in `SharedPreferences`.
  - **AuthInterceptor Overhaul**:
    - Implemented a `Completer<bool>` mutex lock to queue and synchronize concurrent 401 requests, guaranteeing that only a single token refresh network call is dispatched.
    - Used a clean, unintercepted `Dio` instance for token refresh to avoid recursive interceptor loops.
    - Atomically persisted refreshed tokens to `CacheService`.
    - Added automatic session termination and redirection to `AppRouter.login` on refresh token expiry or failure.
  - **Token Initialization**: Updated `AuthRepository` (`login`, `register`, `verifyOtp`) to immediately initialize `AuthInterceptor.setTokens(...)`, ensuring subsequent API calls immediately carry the `Bearer` token without requiring an app restart.
  - **Unified & Atomic Logout**: Implemented `AuthRepository.logout()` and `AuthNotifier.logout()`, invalidating backend sessions, clearing `SharedPreferences` session data, and wiping in-memory tokens.
  - **UI Bindings**: Replaced bare `context.go` calls across `MenuBottomSheet`, `ProfileModal`, and `ProfileActions` with `ref.read(authNotifierProvider.notifier).logout()`, guaranteeing clean logout and re-login behavior.

---

### [COMMIT #060] - Prevent Redundant Token Refresh & 401 on Logout
- **Date & Time:** October 24, 2026 | 11:00 PM
- **Feature Name:** `logout-debounce-and-safe-termination`
- **Git Additions & Updates:**
  - `lib/core/network/interceptors/auth_interceptor.dart`
  - `lib/features/auth/data/datasources/auth_remote_data_source.dart`
  - `lib/features/auth/domain/repositories/auth_repository.dart`
  - `lib/features/auth/presentation/providers/auth_provider.dart`
  - `android/app/src/main/AndroidManifest.xml`
- **What Was Done:**
  - **Diagnosed 401 on Logout**: Traced user error report where `/api/v1/auth/logout` was called twice: the first call refreshed the expired token and succeeded with 200, while a rapid second tap/dispatch sent `AUTH: null` because tokens were already cleared in memory, causing a 401 Unauthorized rejection.
  - **No Refresh on Logout**: Configured `AuthInterceptor.onError` to explicitly skip token refresh if the path is `/api/v1/auth/logout`, immediately resolving locally since the session is already terminated.
  - **Logout Reentrancy Guard**: Added `_isLoggingOut` and `isLoading` debounce locks in `AuthRepository` and `AuthNotifier` to prevent multiple concurrent or duplicate logout network calls.
  - **Token Null Guard**: Verified that `/api/v1/auth/logout` is only called when an active `accessToken` is present in memory.
  - **Benign 401 Handling**: Added `validateStatus: (status) => status != null && status < 500` to `AuthRemoteDataSource.logout()` so expired sessions do not throw unhandled Dio exceptions during logout.
  - **Android Warning Fix**: Added `android:enableOnBackInvokedCallback="true"` to `AndroidManifest.xml` to eliminate Android predictive back navigation warning.


