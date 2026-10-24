# Project Progress & Development Log

This document maintains a chronological record of all features, architecture updates, architectural components, and UI implementations added to the project.

---

## 🚀 Commit Log & Development History

### [COMMIT #001] to [COMMIT #052] - Core Architecture, Auth, Dashboard, API Integration, Global Loader, Caching, Floating Navbar, Menu Sheet, Navbar Profile Integration, Modern Profile Redesign, Menu Accordions, Dashboard Sparklines, Card Shadows, Title Removal, Divider Cleanup, Drivvo Menu Redesign, Apple Health Cards, Splash, Onboarding, Unified Buttons, Modern Register, Google/WhatsApp Assets, Full-Screen Onboarding, Menu Features Alignment, Full-Screen Onboarding Cards, Modern Login/Register Redesign, Customers Module, Add Customer Navigation Link, StringManager Centralization, Android Manifest Permissions, Trading, Profit & Loss Reports Module, CODING_STANDARD.md, AI-Era Profile Settings, Register API Integration, Corrected Basic Auth Token, Company Settings Page, Invoice Settings Page, Profile Settings Navigation, Section Repositioning, Company Settings Overflow Fix, Theme-Colored Shadows, Validators StringManager Centralization, Register Challenge Fix, GSTIN API Error Handling, Session Persistence & Money-First Header Dashboard
- **What Was Done:** Established feature-based modular structure, Light/Dark themes, Inter typography, Login/Register pages, Repository & Data sources, API interceptors, Global Loader, Caching, Android configuration, modern SliverAppBar Dashboard, Navbar menu sheet, Basic Auth alignment, SharedPreferences initialization, floating animated bottom navigation bar, profile navbar integration, modern profile page redesign, expandable menu accordions with sub-menus, sparkline metric cards, prominent card shadows with gradients, title removal, divider cleanup, Drivvo-inspired menu redesign, Apple Health widget cards, splash screen, onboarding story view, unified custom button styling, onboarding paginator view, modern register page, custom asset icons, full-screen onboarding, menu feature alignment, full-screen onboarding cards layout, modern login/register card redesign, customers module, add customer page, customer navigation wiring, string centralization, manifest permissions, trading, profit & loss reports module, coding standard guide, AI-era profile settings, register API integration, corrected Basic Auth token, company settings page, invoice settings page, profile settings navigation, section repositioning, company settings overflow fix, theme-colored shadows, validator string centralization, register challenge fix, GSTIN error handling, session persistence, and money-first header dashboard.

---

### [COMMIT #053] - PDF-Exact Dashboard & 5-Tab Bottom Navbar Alignment (B · Money-first Header.pdf)
- **Date & Time:** February 25, 2026 | 10:45 PM
- **Feature Name:** `pdf-exact-dashboard-navbar-alignment`
- **Git Additions:**
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/dashboard/presentation/widgets/income_expense_summary_card.dart`
  - `lib/features/dashboard/presentation/widgets/overview_metrics_grid.dart`
  - `lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart`
- **What Was Done:**
  - Redesigned the dashboard and bottom navigation bar to **match the exact reference screenshot** from `B · Money-first Header.pdf`.
  - Implemented the 5-tab floating bottom navigation bar (`Home`, `Invoices`, `[+]` center FAB, `Purchase`, `More`).
  - Added the exact **Income vs Expense** summary card with profit margin (`39.81%`), total income, and total expense.
  - Added the 4-grid **Overview** metrics with exact values (`₹2.98 Cr`, `₹1.86 Cr`, `₹2.12 Cr`, `₹11.84 L`).
  - Verified static analysis (`flutter analyze`) and test suite (`flutter test`) passing with zero errors or warnings.

---

### [COMMIT #013] - Client-Choice UI Revamp: Dashboard & Bottom Navigation Bar
- **Date & Time:** October 24, 2026 | 07:45 PM
- **Feature Name:** `client-choice-dashboard-navbar-revamp`
- **Git Additions & Updates:**
  - `lib/core/res/color_manager.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/dashboard/presentation/pages/main_dashboard_layout.dart`
  - `lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart`
  - `lib/features/dashboard/presentation/widgets/income_expense_summary_card.dart`
  - `lib/features/dashboard/presentation/widgets/overview_metrics_grid.dart`
  - `lib/features/dashboard/presentation/widgets/quick_actions_card.dart`
  - `lib/features/dashboard/presentation/widgets/flow_chart_card.dart`
  - `lib/features/dashboard/presentation/widgets/recent_activity_list.dart`
- **What Was Done:**
  - **Bottom Navigation Bar:** Placed the **Home icon (`Icons.home_rounded`)** inside the prominent elevated circular green button in the center instead of a plus icon. Added 4 tabs around it (`Sales`, `Invoices`, `Purchase`, `More` with 4-square grid icon).
  - **Dashboard Header:** Revamped the forest green header with `AS` user avatar, company name "Kumar Electricals", GSTIN, search, notification bell with orange badge "3", support headset icon, greeting "Welcome back, Arpan", and `FY 2026-27 v` dropdown pill.
  - **Income vs Expense Card:** Added `39.81% Profit Margin` highlight, dual income/expense columns with thick color indicator bars (green for Total Income, orange for Total Expense), and period dropdown.
  - **Overview Metrics Grid:** Implemented 2x2 grid for `Tax Invoices`, `E-Way Bills`, `Purchase Invoices`, and `Credit Notes` with customized icon containers, metrics, trend percentages, and custom-painted wave sparklines.
  - **Quick Actions & Import Banner:** Implemented 6 circular actions (`Create Invoice`, `Create Purchase`, `E-Way Bill`, `Record Payment`, `Add Expense`, `GST Filing`) and the warm-peach `Save time! Import your invoices` banner with the `Import Now` button.
  - **Flow Chart:** Implemented period filter pills (`12M`, `6M`, `3M`, `7D`), legend filter chips, multi-line spline chart with axes labels, and the `Oct 2026` gross profit breakdown box.
  - **Recent Activity:** Grouped activities into `TODAY`, `YESTERDAY`, and `22 OCT 2026` with colored badge tags and relative timestamps matching the client design.

---

### [UPDATE] - Navigation Alignment & Screen Mapping
- **Date & Time:** October 24, 2026 | 07:55 PM
- **Changes Applied:**
  - **Index 0:** Replaced Sales with **Report** (`Icons.bar_chart_rounded`) pointing to [`ReportsPage()`](file:///d:/Flutter%20BackUp/new_code/lib/features/reports/presentation/pages/reports_page.dart).
  - **Index 1:** **Invoices** (`Icons.description_outlined`) pointing to [`InvoicesPage()`](file:///d:/Flutter%20BackUp/new_code/lib/features/invoice/presentation/pages/invoices_page.dart).
  - **Index 2 (Center):** **Home** ([`Icons.home_rounded`](file:///d:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart)) inside the circular elevated green button, populating [`DashboardPage()`](file:///d:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/pages/dashboard_page.dart) as the primary home screen.
  - **Index 3:** Replaced Purchase with **Customer** (`Icons.people_outline_rounded`) pointing to [`CustomersPage()`](file:///d:/Flutter%20BackUp/new_code/lib/features/customer/presentation/pages/customers_page.dart).
  - **Index 4:** **More** (`Icons.grid_view_rounded`) opening the quick menu bottom sheet.

---

### [UPDATE] - Navbar Rounded Corners, Theme Shadow & Customer Page Action Bar Cleanup
- **Date & Time:** October 24, 2026 | 08:00 PM
- **Changes Applied:**
  - **Navbar UI Curves & Shadow:** Added curved top-left and top-right corners (`Radius.circular(24)`) and an ambient theme-colored shadow glow (`ColorManager.primaryGreen` with blur radius 24 and spread 2) to [`ModernBottomNavBar`](file:///d:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart).
  - **Manage Customers Action Bar:** Removed the duplicate `+` icon button from the top `AppBar` actions in [`CustomersPage`](file:///d:/Flutter%20BackUp/new_code/lib/features/customer/presentation/pages/customers_page.dart), keeping the existing `FloatingActionButton` as the designated action for adding customers.

---

### [COMMIT #014] - Functional Interactive Dashboard Dropdowns & Dynamic Demo Datasets
- **Date & Time:** October 24, 2026 | 08:05 PM
- **Feature Name:** `functional-dashboard-dropdowns-demo-data`
- **Git Additions & Updates:**
  - `lib/features/dashboard/presentation/providers/dashboard_provider.dart`
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/dashboard/presentation/widgets/income_expense_summary_card.dart`
  - `lib/features/dashboard/presentation/widgets/overview_metrics_grid.dart`
  - `lib/features/dashboard/presentation/widgets/flow_chart_card.dart`
- **What Was Done:**
  - **Financial Year Dropdown (`setFY`):** Enabled functional dropdown in the top header with options `FY 2026-27`, `FY 2025-26`, and `FY 2024-25`. Selecting any year updates the whole dashboard's metrics, profit margins, and overview cards.
  - **Income vs Expense Period Dropdown (`setIncomeExpensePeriod`):** Added interactive dropdown menu with options `This Month`, `Last Month`, `This Quarter`, and `This Financial Year`. Seamlessly animates and recalculates the profit margin percentage, total income, total expense, and dynamic progress bar ratios.
  - **Overview Period Dropdown (`setOverviewPeriod`):** Added interactive dropdown menu with options `This FY`, `This Quarter`, `This Month`, and `Last FY`. Recalculates all 4 cards (Tax Invoices, E-Way Bills, Purchase Invoices, Credit Notes) with distinct amounts, invoice counts, trend percentages, and responsive wave sparklines.
  - **Flow Chart Interactive Filters (`setFlowRange`):** Wired `12M`, `6M`, `3M`, and `7D` buttons to dynamically reload chart spline curves, timeline months, and the summary detail box figures (Sale, Purchase, Credit Note, Gross Profit, and Profit %).

---

### [UPDATE] - Dynamic Unselected State for Home Navbar Button
- **Date & Time:** October 24, 2026 | 08:15 PM
- **Changes Applied:**
  - In [`ModernBottomNavBar`](file:///d:/Flutter%20BackUp/new_code/lib/features/dashboard/presentation/widgets/modern_bottom_nav_bar.dart), updated the center Home button to adapt dynamically based on `isSelected`:
    - **Selected (Index 2):** Highlights with `ColorManager.primaryGreen`, white `Icons.home_rounded`, bold green label, and a green glow shadow.
    - **Unselected (Other Index Active):** Gracefully shifts to an unselected neutral style (light grey `#F1F5F9` / dark grey `#334155`), unselected icon color (`#64748B`), `Icons.home_outlined`, regular label style, and soft ambient shadow.
