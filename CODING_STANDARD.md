# GSTSOF Flutter Application - Coding Standards & Architecture Guidelines

This document defines the strict coding standards, architectural patterns, and design guidelines for developing features in the GSTSOF Flutter application. **All future code changes and feature implementations must adhere strictly to these guidelines.**

---

## 1. Feature-Based Modular Architecture

All code must be organized into decoupled features and core modules:

```text
lib/
├── core/
│   ├── network/          # ApiClient, ApiEndpoints, ApiException, Interceptors
│   ├── res/              # ColorManager, FontManager, StylesManager, StringManager
│   ├── router/           # AppRouter (GoRouter configuration)
│   ├── services/         # CacheService, ConnectivityService
│   └── widgets/          # GlobalLoader, CustomButton, CustomTextField, NoInternetWidget, etc.
└── features/
    ├── auth/             # Login, Register, Splash, Onboarding
    ├── dashboard/        # Dashboard home, SliverAppBar, MenuBottomSheet, ModernBottomNavBar
    ├── customer/         # Customers list, AddCustomerPage
    ├── invoice/          # Purchase/Incoming invoices, CreateInvoicePage
    ├── reports/          # Trading, Profit & Loss Report
    └── profile/          # Profile details & company overview
```

---

## 2. Strict String Centralization Rule (`StringManager`)

> [!IMPORTANT]
> **NEVER use raw hardcoded strings in UI widgets, pages, or models.** 
> Every user-facing string, label, hint, error message, or feedback text **must** be defined first in `StringManager` (`lib/core/res/string_manager.dart`) and then referenced via `StringManager.someString`.

---

## 3. State Management (`flutter_riverpod`)

- Use `flutter_riverpod` (`^2.6.1`) for reactive state management.
- Implement stateful business logic using `StateNotifier` and `StateNotifierProvider`.
- Decouple providers in `presentation/providers/{feature}_provider.dart`.

```dart
final myFeatureNotifierProvider = StateNotifierProvider<MyFeatureNotifier, MyFeatureState>((ref) {
  return MyFeatureNotifier();
});
```

---

## 4. Declarative Routing (`go_router`)

- Manage navigation using `go_router` (`^14.6.2`) configured centrally in `AppRouter` (`lib/core/router/app_router.dart`).
- Use `context.push(AppRouter.someRoute)` for pushing new pages and `context.go(AppRouter.someRoute)` for root navigation.

---

## 5. Networking & API Integration (`dio`)

- Use the singleton `ApiClient` (`lib/core/network/api_client.dart`) configured with Dio.
- `AuthInterceptor` automatically injects Basic Auth client credentials (`client_id` and `client_secret`) for auth routes and Bearer tokens for authenticated routes.
- `ConnectivityService` checks internet connectivity prior to network requests, throwing a clean `ApiException` handled by `NoInternetWidget` when offline.

---

## 6. Modern UI & Widget Separation

- **Widget Separation**: Never write monolithic pages. Break down UI into modular widgets under `presentation/widgets/` (e.g. `ReportFilterCard`, `ReportSectionCard`, `MetricCardWithChart`).
- **Card Styling**: Use modern floating card containers with rounded corners (`BorderRadius.circular(20)` to `28`), subtle multi-stop gradients, and ambient depth shadows (`BoxShadow` with blur radius 16–30).
- **Typography & Colors**: Use `StylesManager` (`getBoldStyle`, `getMediumStyle`, `getRegularStyle`) with Google Fonts **Inter**.

---

## 7. Quality Assurance

Before completing any task, ensure:
1. Static analysis (`flutter analyze`) returns **0 errors or warnings**.
2. Test suite (`flutter test`) passes successfully.
