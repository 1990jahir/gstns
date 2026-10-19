# Implementation Plan: API Integration, Modern Mobile Dashboard & Animated Gradients

This plan outlines the implementation of real API integration using our Dio client and Postman/cURL specifications, a complete redesign of the Dashboard into a modern mobile-first UI with a gradient `SliverAppBar` and a sleek `GridView`, and the addition of **animated gradient buttons and selection states** across all interactive elements.

## User Review Required

> [!IMPORTANT]
> **API Base URL & Credentials**: We will connect authentication calls to `https://gstsof.com` using the Basic Auth credentials (`01a14e3c-cf62-7271-b65e-9a822a42bd27:yMe1tn3mT71PYx4iR5HYAeYd1LMju0Hd1VtIxrk`) from your specification.

> [!IMPORTANT]
> **Animated Gradients & Selection Effects**: All primary buttons, quick action tiles, selection cards, and dropdown containers will feature rich gradients, dynamic box shadows, and smooth scale/tap press animations.

## Proposed Changes

### 1. API Integration Layer (`lib/features/auth/data/`)
- **[NEW] [auth_remote_data_source.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/auth/data/datasources/auth_remote_data_source.dart)**: Remote data source implementing login, token refresh, send OTP, verify OTP, and get me.
- **[NEW] [auth_repository.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/auth/domain/repositories/auth_repository.dart)**: Repository wrapper handling error mapping (`ApiException`) and session caching (`CacheService`).
- **[MODIFY] [auth_provider.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/auth/presentation/providers/auth_provider.dart)**: Wire up state notifier to invoke repository methods and manage loading/error/success states.

### 2. Modern Mobile Dashboard UI Redesign (`lib/features/dashboard/presentation/pages/dashboard_page.dart`)
- **[MODIFY] [dashboard_page.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/pages/dashboard_page.dart)**:
  - Replace flat AppBar with a stunning **Gradient `SliverAppBar`** featuring collapsing behavior, welcome back greeting, support badge, notifications, and profile avatar.
  - Implement a modern **`GridView.builder`** for metric cards with refined card shadows, rounded corners, and gradient accents.
  - Reorganize Quick Actions, Income vs Expense, and Recent Activity into cohesive, modern card containers.

### 3. Animated Gradient Buttons & Selection Elements (`lib/core/widgets/`)
- **[MODIFY] [custom_button.dart](file:///D:/Flutter%20BackUp/new_code/lib/core/widgets/custom_button.dart)**: Enhance with scale-down tap animations (`GestureDetector` / `ScaleTransition`) and multi-stop vibrant gradients with depth shadows.
- **[MODIFY] [quick_actions_card.dart](file:///D:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/widgets/quick_actions_card.dart)**: Add animated gradient selection states and press bounce effects.

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure widget and unit tests pass.
- Run `flutter analyze` to verify zero static analysis errors or warnings.

### Manual Verification
- Test login with real API calls.
- Inspect the animated gradient buttons and selection states across pages.
