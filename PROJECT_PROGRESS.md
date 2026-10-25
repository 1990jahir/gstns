# Project Progress & Development Log

This document maintains a chronological record of all features, architecture updates, architectural components, and UI implementations added to the project.

---

## 🚀 Commit Log & Development History

### [COMMIT #001] to [COMMIT #055] - Core Architecture, Auth, Dashboard, API Integration, Global Loader, Caching, Floating Navbar, Menu Sheet, Navbar Profile Integration, Modern Profile Redesign, Menu Accordions, Dashboard Sparklines, Card Shadows, Title Removal, Divider Cleanup, Drivvo Menu Redesign, Apple Health Cards, Splash, Onboarding, Unified Buttons, Modern Register, Google/WhatsApp Assets, Full-Screen Onboarding, Menu Features Alignment, Full-Screen Onboarding Cards, Modern Login/Register Redesign, Customers Module, Add Customer Navigation Link, StringManager Centralization, Android Manifest Permissions, Trading, Profit & Loss Reports Module, CODING_STANDARD.md, AI-Era Profile Settings, Register API Integration, Corrected Basic Auth Token, Company Settings Page, Invoice Settings Page, Profile Settings Navigation, Section Repositioning, Company Settings Overflow Fix, Theme-Colored Shadows, Validators StringManager Centralization, Register Challenge Fix, GSTIN API Error Handling, Session Persistence, Money-First Header Dashboard, PDF-Exact Dashboard Navbar Alignment, Inter Font Style Consistency & GlobalInputField Prefix Icon
- **What Was Done:** Established feature-based modular structure, Light/Dark themes, Inter typography, Login/Register pages, Repository & Data sources, API interceptors, Global Loader, Caching, Android configuration, modern SliverAppBar Dashboard, Navbar menu sheet, Basic Auth alignment, SharedPreferences initialization, floating animated bottom navigation bar, profile navbar integration, modern profile page redesign, expandable menu accordions with sub-menus, sparkline metric cards, prominent card shadows with gradients, title removal, divider cleanup, Drivvo-inspired menu redesign, Apple Health widget cards, splash screen, onboarding story view, unified custom button styling, onboarding paginator view, modern register page, custom asset icons, full-screen onboarding, menu feature alignment, full-screen onboarding cards layout, modern login/register card redesign, customers module, add customer page, customer navigation wiring, string centralization, manifest permissions, trading, profit & loss reports module, coding standard guide, AI-era profile settings, register API integration, corrected Basic Auth token, company settings page, invoice settings page, profile settings navigation, section repositioning, company settings overflow fix, theme-colored shadows, validator string centralization, register challenge fix, GSTIN error handling, session persistence, money-first header dashboard, PDF-exact dashboard navbar alignment, inter font styling consistency, and global input field enhancement.

---

### [COMMIT #056] - Android & iOS Package Name and Bundle ID Update to `com.gsts.gstsof`
- **Date & Time:** February 25, 2026 | 11:55 PM
- **Feature Name:** `package-name-and-bundle-id-update`
- **Git Additions:**
  - `android/app/build.gradle.kts`
  - `android/app/src/main/kotlin/com/gsts/gstsof/MainActivity.kt`
  - `ios/Runner.xcodeproj/project.pbxproj`
- **What Was Done:**
  - Updated Android `namespace`, `applicationId`, and Kotlin package structure to `com.gsts.gstsof`.
  - Updated iOS bundle identifier (`PRODUCT_BUNDLE_IDENTIFIER`) in `project.pbxproj` for Runner and RunnerTests to `com.gsts.gstsof` and `com.gsts.gstsof.RunnerTests`.
  - Verified static analysis (`flutter analyze`) passing with zero errors or warnings.

---

### [COMMIT #057] - Global Input Field Refactoring & Unified Theme Styling
- **Feature Name:** global-input-field-refactor
- **What Was Done:**
  - Standardized form text fields across all modules to use the global design system component FloatingLabelInput / CustomTextField.
  - Added theme-aware borders, floating labels, hint typography, and suffix icon controls.

---

### [COMMIT #058] - Input Field Selection & Background Color Correction
- **Feature Name:** input-box-grey-selection-fix
- **What Was Done:**
  - Resolved text selection highlighting and unwanted grey background tints during active user input.
  - Set selectionColor and cursorColor according to the active theme palette with crisp contrast.

---

### [COMMIT #059] - Mutex-Protected Token Refresh & 401 Session Handling
- **Feature Name:** session-management-and-token-refresh
- **What Was Done:**
  - Implemented automatic token refreshing in AuthInterceptor on HTTP 401 responses.
  - Added a Completer<bool> mutex lock to synchronize concurrent 401 requests, preventing duplicate refresh calls.
  - Automatically retried original requests with the newly minted access token.

---

### [COMMIT #060] - Logout Reentrancy Lock & 401 Suppression
- **Feature Name:** logout-reentrancy-and-error-fix
- **What Was Done:**
  - Fixed duplicate rapid logout taps resulting in 401 Unauthorized errors when ccessToken was already cleared.
  - Added _isLoggingOut lock in AuthRepository and guarded AuthInterceptor.onError for /auth/logout endpoints.

---

### [COMMIT #061] - Universal SafeArea Normalization Across All 17 Pages
- **Feature Name:** safearea-bottom-only-normalization
- **What Was Done:**
  - Configured SafeArea(top: false, bottom: true) across all 17 page bodies, dialogs, drawers, and bottom sheets so that the status bar is never cut off or pushed down.
  - Set statusBarColor: Colors.transparent with adaptive icon brightness (dark icons in light mode, light icons in dark mode).

---

### [COMMIT #062] - Proof-of-Work Bot Check Service & Registration GSTIN Lookup
- **Feature Name:** pow-bot-check-and-gstin-lookup
- **Git Additions / Updates:**
  - lib/core/services/challenge_service.dart
  - lib/core/network/api_endpoints.dart
  - lib/features/auth/data/models/gstin_lookup_model.dart
  - lib/features/auth/data/datasources/auth_remote_data_source.dart
  - lib/features/auth/domain/repositories/auth_repository.dart
  - lib/features/auth/presentation/providers/register_provider.dart
  - lib/features/auth/presentation/pages/register_page.dart
  - lib/features/auth/presentation/widgets/register_business_pane.dart
- **What Was Done:**
  - Built ChallengeService executing SHA-256 Proof-of-Work leading zero bit search inside a background Isolate.run off the main thread (zero UI frame drops).
  - Integrated /api/v1/auth/challenge to generate single-use X-Challenge and X-Challenge-Nonce headers for unauthenticated requests.
  - Integrated POST /api/v1/register/gstin-lookup with Basic Auth and solved PoW challenge headers.
  - Auto-populated registration fields: company_name (or trade_name), first_name, and last_name upon receiving GSTIN details.
  - Handled lready_registered == true to warn the user and prompt them to log in.
  - Wired live digital business ID card verification badge and shine animation upon successful verification.

---

### [COMMIT #063] - Full Registration Flow Integration (Challenge + Send OTP + Verify OTP + Register)
- **Feature Name:** registration-flow-api-integration
- **Git Additions / Updates:**
  - lib/features/auth/data/models/register_flow_models.dart
  - lib/features/auth/data/datasources/auth_remote_data_source.dart
  - lib/features/auth/domain/repositories/auth_repository.dart
  - lib/features/auth/presentation/providers/register_provider.dart
  - lib/features/auth/presentation/pages/register_page.dart
  - lib/features/auth/presentation/pages/verify_otp_page.dart
  - lib/core/router/app_router.dart
  - lib/core/network/api_exception.dart
- **What Was Done:**
  - Implemented complete 4-step registration sequence per GSTSOF Mobile Integration API Specification v1.1:
    1. **Bot Check**: Fresh PoW challenge requested from `POST /api/v1/auth/challenge` and solved in background isolate before each step.
    2. **Send WhatsApp OTP**: `POST /api/v1/register/otp/send` with Basic Auth + `X-Challenge` / `X-Challenge-Nonce` and E.164 mobile number (`+91XXXXXXXXXX`), capturing `otp_session_token` and `resend_in` cooldown.
    3. **Verify WhatsApp OTP**: `POST /api/v1/register/otp/verify` with Basic Auth + fresh solved challenge, receiving `signup_token` (valid 30 minutes).
    4. **Create Account**: `POST /api/v1/register` with `signup_token`, `user_type` (3 for Registered, 7 for Unregistered), `gstin` or `pan_no`, `company_name`, `first_name`, `last_name`, `email`, `password`, `password_confirmation`, and `referral_code`.
  - Created type-safe models: `RegisterOtpSendData`, `RegisterOtpVerifyData`, `RegisterPayload`, and `RegisterAccountResponse`.
  - Upgraded `VerifyOtpPage`:
    - Clean WhatsApp branding and formatted mobile display (`+91 XXXXX XXXXX`).
    - 6-digit individual PIN input boxes with auto-advance and backspace retreat.
    - Live 60-second cooldown timer for resending OTP (`resend_in`).
    - Error banner displaying specific backend failure messages (e.g. `Incorrect OTP. 4 attempts left.`).
    - Auto-submits on the 6th digit to verify OTP, create the account, save session tokens, and route directly to the Dashboard.
