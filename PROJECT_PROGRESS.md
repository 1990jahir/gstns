# Project Progress & Development Log

This document maintains a chronological record of all features, architecture updates, architectural components, and UI implementations added to the project.

---

## 🚀 Commit Log & Development History

### [COMMIT #001] to [COMMIT #056] - Core Architecture, Auth, Dashboard, API Integration, Global Loader, Caching, Floating Navbar, Menu Sheet, Navbar Profile Integration, Modern Profile Redesign, Menu Accordions, Dashboard Sparklines, Card Shadows, Title Removal, Divider Cleanup, Drivvo Menu Redesign, Apple Health Cards, Splash, Onboarding, Unified Buttons, Modern Register, Google/WhatsApp Assets, Full-Screen Onboarding, Menu Features Alignment, Full-Screen Onboarding Cards, Modern Login/Register Redesign, Customers Module, Add Customer Navigation Link, StringManager Centralization, Android Manifest Permissions, Trading, Profit & Loss Reports Module, CODING_STANDARD.md, AI-Era Profile Settings, Register API Integration, Corrected Basic Auth Token, Company Settings Page, Invoice Settings Page, Profile Settings Navigation, Section Repositioning, Company Settings Overflow Fix, Theme-Colored Shadows, Validators StringManager Centralization, Register Challenge Fix, GSTIN API Error Handling, Session Persistence, Money-First Header Dashboard, PDF-Exact Dashboard Navbar Alignment, Inter Font Style Consistency, GlobalInputField Prefix Icon, Theme-Colored Card Shadows & Package ID Update
- **What Was Done:** Established feature-based modular structure, Light/Dark themes, Inter typography, Login/Register pages, Repository & Data sources, API interceptors, Global Loader, Caching, Android configuration, modern SliverAppBar Dashboard, Navbar menu sheet, Basic Auth alignment, SharedPreferences initialization, floating animated bottom navigation bar, profile navbar integration, modern profile page redesign, expandable menu accordions with sub-menus, sparkline metric cards, prominent card shadows with gradients, title removal, divider cleanup, Drivvo-inspired menu redesign, Apple Health widget cards, splash screen, onboarding story view, unified custom button styling, onboarding paginator view, modern register page, custom asset icons, full-screen onboarding, menu feature alignment, full-screen onboarding cards layout, modern login/register card redesign, customers module, add customer page, customer navigation wiring, string centralization, manifest permissions, trading, profit & loss reports module, coding standard guide, AI-era profile settings, register API integration, corrected Basic Auth token, company settings page, invoice settings page, profile settings navigation, section repositioning, company settings overflow fix, theme-colored shadows, validator string centralization, register challenge fix, GSTIN error handling, session persistence, money-first header dashboard, PDF-exact dashboard navbar alignment, inter font styling consistency, global input field enhancement, theme-colored card shadows, and package ID update.

---

### [COMMIT #057] - Removal of Unrequested Modules
- **Date & Time:** February 25, 2026 | 11:59 PM
- **Feature Name:** `remove-unrequested-modules`
- **Git Additions/Removals:**
  - Removed unrequested feature directories (`inventory`, `eway_bill`, `einvoice`, `gstr_filing`).
  - Cleaned up `AppRouter` routes and imports.
- **What Was Done:**
  - Removed all unrequested temporary modules to keep the project scoped strictly to the requested feature set (Dashboard, Invoices, Customers, Reports, and Profile/Settings).
  - Verified static analysis (`flutter analyze`) returns zero errors.

---

### [COMMIT #058] - Global SafeArea Bottom & Status Bar Preservation
- **Date & Time:** October 24, 2026
- **Feature Name:** `safe-area-status-bar-fix`
- **What Was Done:**
  - Audited global SafeArea usage across all scaffolding.
  - Restricted SafeArea padding to bottom-only (`bottom: true, top: false`) where appropriate to prevent status bar cutoff and maintain full-bleed immersive status bar styling across Android and iOS.

---

### [COMMIT #059] - Proof-of-Work Challenge Service Integration
- **Date & Time:** October 25, 2026
- **Feature Name:** `pow-challenge-service`
- **What Was Done:**
  - Implemented `ChallengeService` in `lib/core/services/challenge_service.dart`.
  - Added off-thread SHA-256 brute-force solver using `compute` to solve dynamic difficulty challenges within ~1000ms without blocking UI.
  - Bound challenge lifecycle headers (`X-Challenge`, `X-Challenge-Nonce`) for bot-protected endpoints (`/api/v1/auth/challenge`, `/api/v1/register/gstin-lookup`).

---

### [COMMIT #060] - Real-Time GSTIN Lookup with Live Digital ID Card
- **Date & Time:** October 25, 2026
- **Feature Name:** `gstin-lookup-digital-card`
- **What Was Done:**
  - Integrated `/api/v1/register/gstin-lookup` API for instant business detail resolution.
  - Implemented an animated digital business ID card preview widget in the registration flow with shimmer loading and auto-filled business/legal/trade names and PAN.

---

### [COMMIT #061] - WhatsApp OTP Verification & Multi-Step Registration UI
- **Date & Time:** October 25, 2026
- **Feature Name:** `register-multistep-otp-ui`
- **What Was Done:**
  - Designed multi-step registration flow: Step 1 (Business Identity - Registered/Unregistered) -> Step 2 (Account & WhatsApp Credentials).
  - Built password strength indicator with real-time criteria validation.
  - Added custom WhatsApp brand asset and UI banners communicating automated OTP dispatch via WhatsApp.

---

### [COMMIT #062] - Dedicated 6-Digit PIN Verify OTP Page
- **Date & Time:** October 25, 2026
- **Feature Name:** `verify-otp-page`
- **What Was Done:**
  - Created `VerifyOtpPage` (`lib/features/auth/presentation/pages/verify_otp_page.dart`) with six individual PIN input boxes, autofocus chaining, 60s cooldown timer, and resend OTP capabilities.
  - Configured router integration passing target phone number via `GoRouterState.extra`.

---

### [COMMIT #063] - Complete Register API Flow Integration
- **Date & Time:** October 25, 2026
- **Feature Name:** `register-api-flow-integration`
- **What Was Done:**
  - Created `RegisterFlowModels` (`RegisterOtpSendData`, `RegisterOtpVerifyData`, `RegisterPayload`, `RegisterAccountResponse`) in `lib/features/auth/data/models/register_flow_models.dart`.
  - Added remote data source methods and repository functions: `sendRegisterOtp`, `verifyRegisterOtp`, and `registerUser`.
  - Chained OTP verification completion directly to automatic account creation and authenticated session startup.

---

### [COMMIT #064] & [COMMIT #065] - API Credentials Alignment & Error Diagnostics
- **Date & Time:** October 25, 2026
- **Feature Name:** `credentials-alignment-logging`
- **What Was Done:**
  - Restored verified working Basic Auth credentials and Client IDs in `lib/core/network/api_endpoints.dart`:
    - `basicAuthToken`: `MDFhMTNhN2UtNjViNS03MWJlLWExNGYtZDNmOTk3OTY0MjAxOkM3TzliTXFlbWtab2t3RERGRzJpTng1UDNsVHBJOUJwUTVKVXpFTGM=`
    - `defaultClientId`: `01a13a7e-65b5-71be-a14f-d3f997964201`
    - `defaultClientSecret`: `C7O9bMqemkZokwDDFG2iNx5P3lTpI9BpQ5JUzETLc`
  - Upgraded `LoggingInterceptor` to output exact server response bodies for 4xx/5xx errors.
  - Re-routed `ChallengeService` to use singleton `ApiClient().dio` for consistent logging and pooled network requests.

---

### [COMMIT #066] - E.164 Phone Format Normalization
- **Date & Time:** October 25, 2026
- **Feature Name:** `e164-phone-format-fix`
- **What Was Done:**
  - Fixed mobile number validation error (`422 VALIDATION_FAILED: The mobile number must be in E.164 format, e.g. +919876543210`).
  - Added standard E.164 normalization logic across `auth_repository.dart`, `register_provider.dart`, and `register_page.dart`:
    `final digits = mobile.replaceAll(RegExp(r'[^0-9]'), '');`
    `final formatted = '+91${digits.length >= 10 ? digits.substring(digits.length - 10) : digits}';`

---

### [COMMIT #067] - Comprehensive Web Portal Flow, Architecture Mapping & Mobile Design Standard
- **Date & Time:** November 24, 2026
- **Feature Name:** `web-portal-architecture-and-mobile-roadmap`
- **What Was Done:**
  - Conducted thorough architectural inspection of the live GSTSOF web portal (`https://gstsof.com/user/dashboard` and associated sub-routes).
  - Documented the full website functional structure across 9 core modules.
  - Formulated the **Dual-Tab Authentication Architecture** (`Client` vs `Partner`) for both Login and Registration.
  - Defined the client-approved **Dashboard UI Standard** as the universal visual and architectural baseline.
  - Established the 6-phase implementation roadmap for the entire mobile application.

---

### [COMMIT #068] - Phase 1: Dual-Tab Authentication (Client & Partner for Login and Registration)
- **Date & Time:** November 24, 2026
- **Feature Name:** `dual-tab-auth-client-partner`
- **What Was Done:**
  - Created reusable `AuthRoleSegmentedSwitch` (`lib/features/auth/presentation/widgets/auth_role_segmented_switch.dart`) with smooth animated pill transitions, primary green highlights, and theme support.
  - Upgraded `LoginPage` (`lib/features/auth/presentation/pages/login_page.dart`) with the segmented switch between `Client` and `Partner`:
    - Client Form: Standard business credentials, password visibility toggle, WhatsApp & Google login, and dynamic routing to Register.
    - Partner Form: Dedicated "PARTNER ACCESS PORTAL" banner with verified credentials badge, Partner Email/Membership No. input, and link to Partner Network onboarding.
  - Upgraded `RegisterPage` (`lib/features/auth/presentation/pages/register_page.dart`) with the segmented switch and added `RegisterPartnerPane`:
    - Professional Category chips: `Chartered Accountant (CA)`, `Tax Practitioner (ITP/STP)`, `Advocate / Legal Consultant`, `Accounting Firm / Consultant`.
    - Membership / COP / Bar Council Registration Number.
    - Firm / Practice Name, City, State, Partner Name, Email, WhatsApp Phone (+91 verification), and Password confirmation.
  - Centralized 100% of labels, hints, banners, and error validation strings in `StringManager`.

---

### [COMMIT #069] - Phases 2–6: Complete Mobile Portal Suite Implementation & Menu Routing
- **Date & Time:** November 24, 2026
- **Feature Name:** `full-mobile-portal-suite-and-menu-routing`
- **What Was Done:**
  - **Phase 2 (Sales & Customer Suite)**:
    - Upgraded `InvoicesPage` (`lib/features/invoice/presentation/pages/invoices_page.dart`) with fintech metric summary cards, status filters (`All`, `Unpaid`, `Paid`, `Overdue`), fast search, WhatsApp share, and PDF export.
    - Created `CreditNotesPage` (`lib/features/invoice/presentation/pages/credit_notes_page.dart`) for sales returns & adjustments.
    - Created `DeliveryChallansPage` (`lib/features/invoice/presentation/pages/delivery_challans_page.dart`) for transport of goods & job work.
  - **Phase 3 (Purchase & Vendor Suite)**:
    - Created `VendorsPage` (`lib/features/purchase/presentation/pages/vendors_page.dart`) with supplier records, GSTIN, PAN, and payable balance ledgers.
    - Created `PurchaseBillsPage` (`lib/features/purchase/presentation/pages/purchase_bills_page.dart`) with ITC claim status indicators.
    - Created `IncomingInvoicesPage` (`lib/features/purchase/presentation/pages/incoming_invoices_page.dart`) for automated GSTR-2B inward sync.
    - Created `DebitNotesPage` (`lib/features/purchase/presentation/pages/debit_notes_page.dart`) for purchase return dispute vouchers.
  - **Phase 4 (Masters & Inventory Catalog)**:
    - Created `ItemsPage` (`lib/features/masters/presentation/pages/items_page.dart`) with Goods vs Services tabs, HSN tax slabs, and stock alerts.
    - Created `ItemCategoriesPage` (`lib/features/masters/presentation/pages/item_categories_page.dart`) with hierarchical item grouping.
    - Created `TransportersPage` (`lib/features/masters/presentation/pages/transporters_page.dart`) with TRANSIN and fleet directory.
  - **Phase 5 (Cash, Banking & Expenses)**:
    - Created `BankAccountsPage` (`lib/features/banking/presentation/pages/bank_accounts_page.dart`) with Apple Health-style horizontal card slider and combined liquidity metrics.
    - Created `BankTransactionsPage` (`lib/features/banking/presentation/pages/bank_transactions_page.dart`) with searchable passbook statement.
    - Created `ExpensesPage` (`lib/features/banking/presentation/pages/expenses_page.dart`) with month-wise category pills and GST claimable flags.
    - Created `IncomePage` (`lib/features/banking/presentation/pages/income_page.dart`) for other indirect income tracking.
  - **Phase 6 (GST Compliance & Financial Reports)**:
    - Created `Gstr1Page` (`lib/features/gst/presentation/pages/gstr1_page.dart`) with Table 4A, 5A, 7, 9B, and 12 summaries and JSON portal export.
    - Created `Gstr3bPage` (`lib/features/gst/presentation/pages/gstr3b_page.dart`) with Outward Tax vs Eligible ITC set-off calculation and direct filing action.
    - Created `BalanceSheetPage` (`lib/features/reports/presentation/pages/balance_sheet_page.dart`) with Assets vs Liabilities schedules.
  - **Routing & Navigation Alignment**:
    - Registered all 18+ routes in `AppRouter` (`lib/core/router/app_router.dart`).
    - Wired every sub-menu item in `MenuBottomSheet` (`lib/features/dashboard/presentation/widgets/menu_bottom_sheet.dart`) to trigger instant, smooth navigation directly into the corresponding page.

---

### [COMMIT #070] - Secondary Flow Completion & Quick Actions Integration
- **Date & Time:** November 24, 2026
- **Feature Name:** `secondary-creation-pages-and-actions-completion`
- **What Was Done:**
  - Built `AddItemPage` (`lib/features/masters/presentation/pages/add_item_page.dart`) with Goods vs Services toggle, HSN/SAC input, UOM, and tax slabs.
  - Built `AddVendorPage` (`lib/features/purchase/presentation/pages/add_vendor_page.dart`) with instant 15-char GSTIN auto-fill and bank details.
  - Built `RecordPaymentPage` (`lib/features/banking/presentation/pages/record_payment_page.dart`) with Inward/Outward toggle, payment modes, and bank selector.
  - Built `Gstr2bReconcilePage` (`lib/features/gst/presentation/pages/gstr2b_reconcile_page.dart`) with visual 3-way match progress and one-tap WhatsApp reminder.
  - Built `PartyLedgerPage` (`lib/features/reports/presentation/pages/party_ledger_page.dart`) with running balance statement, PDF download, and WhatsApp share.
  - Built `SubscriptionPage` (`lib/features/profile/presentation/pages/subscription_page.dart`) with Pro plan details and API wallet credit balance.
  - Connected `ItemsPage` FAB -> `AppRouter.addItem`.
  - Connected `VendorsPage` FAB -> `AppRouter.addVendor`.
  - Wired `QuickActionsCard` buttons to trigger real navigation for Invoices, Purchases, Payments, Expenses, GST, and Transporters.
  - 100% of the mobile portal architecture is now fully realized and functional.

---

## 🌐 Complete GSTSOF Web Portal Architecture & Mobile Mapping

### 1. Web Portal Structure Overview (`https://gstsof.com`)
The GSTSOF web ecosystem operates as a comprehensive GST compliance, billing, accounting, and multi-tenant tax management platform for two distinct user groups:
1. **Clients (Businesses)**: Registered (GSTIN) and Unregistered (PAN) MSMEs, retailers, wholesalers, and service providers who generate invoices, manage purchases, track expenses, reconcile GSTR-2B, and view business health reports.
2. **Partners (CAs, Tax Practitioners, Advocates)**: Financial professionals who manage multi-client portfolios, file returns, verify ITC mismatches, and provide compliance services to multiple business clients.

```mermaid
flowchart TD
    subgraph WebPortal["GSTSOF Web Platform (gstsof.com)"]
        Landing["Marketing & Landing Pages"]
        AuthSystem["Authentication & Session Gateway"]
        
        Landing --> AuthSystem
        
        AuthSystem --> ClientPortal["Client Portal (Business Users)"]
        AuthSystem --> PartnerPortal["Partner Portal (CAs & Tax Pros)"]
        
        ClientPortal --> ModDash["1. Dashboard & Cash Flow"]
        ClientPortal --> ModSales["2. Sales & Invoicing (Tax Invoices, Delivery Challans, Credit Notes)"]
        ClientPortal --> ModPurch["3. Purchases & Vendors (Inward Bills, Debit Notes, 2B Sync)"]
        ClientPortal --> ModMast["4. Masters & Catalog (Items, HSN/SAC, Transporters)"]
        ClientPortal --> ModBank["5. Banking & Cash (Passbook, Payments, Receipts)"]
        ClientPortal --> ModExp["6. Expenses & Indirect Costs"]
        ClientPortal --> ModGST["7. GST Compliance (GSTR-1, GSTR-3B, GSTR-2B Recon)"]
        ClientPortal --> ModRep["8. Reports (P&L, Balance Sheet, Ledgers)"]
        ClientPortal --> ModSet["9. Settings & Company Config"]
        
        PartnerPortal --> PartnerClients["Client Directory & Portfolio Management"]
        PartnerPortal --> PartnerCompliance["Multi-Client GST Filing Desk"]
        PartnerPortal --> PartnerAudit["Audit & Reconciliation Workspace"]
    end
```

---

### 2. Functional Web Modules & Mobile Screen Blueprint

#### Module 1: Dashboard (`/dashboard`) — *Current Approved Standard*
* **Web Features**:
  * Real-time net balance & cash position.
  * Inward/Outward billing summary cards.
  * 7-day to 12-month visual revenue & expense trends.
  * Quick billing actions & recent ledger transactions.
* **Mobile Implementation**:
  * Screen: `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  * Architecture: Modern `SliverAppBar`, Inter typography, theme-aware card elevation shadows, animated sparklines, and floating dock bottom navigation (`BottomNavBar`).
  * Status: **Complete & Approved by Client**.

#### Module 2: Sales & Invoicing (`/sales/*`, `/invoices/*`)
* **Web Features**:
  * Tax Invoices (B2B, B2C Large, B2C Small, Export).
  * Quotations / Estimates & Proforma Invoices.
  * Delivery Challans for job-work and movement of goods.
  * Credit Notes (Sales returns & adjustments).
  * Real-time E-Way Bill & E-Invoice (IRN) generation.
* **Mobile Implementation Plan**:
  * `InvoicesPage` (`lib/features/sales/presentation/pages/invoices_page.dart`): Segmented status tabs (`All`, `Unpaid`, `Partially Paid`, `Paid`, `Overdue`), fast search, WhatsApp share, PDF download.
  * `CreateInvoicePage` (`lib/features/sales/presentation/pages/create_invoice_page.dart`): Dynamic line-item creator, automatic GSTIN lookup for customers, real-time CGST/SGST/IGST tax calculation.
  * `CustomersPage` & `AddCustomerPage` (`lib/features/customers/`): Party directory, outstanding ledger balance indicators, 15-character GSTIN instant fetch.
  * `CreditNotesPage` (`lib/features/sales/presentation/pages/credit_notes_page.dart`): Linked return vouchers.

#### Module 3: Purchases & Vendors (`/purchase/*`, `/vendors/*`)
* **Web Features**:
  * Inward purchase bills management.
  * Vendor directory with PAN/GSTIN and payable ledgers.
  * GSTR-2B automatic inward invoice sync.
  * Debit Notes (Purchase returns & disputes).
* **Mobile Implementation Plan**:
  * `PurchaseBillsPage`: Log of inward bills with ITC eligibility badges.
  * `CreatePurchaseBillPage`: Itemized purchase voucher entry with vendor selector.
  * `VendorsPage` & `AddVendorPage`: Supplier directory with outstanding payable chips.
  * `IncomingInvoicesPage`: Direct GSTR-2B invoice stream with auto-reconciliation indicators.
  * `DebitNotesPage`: Debit voucher creation linked to original supplier bills.

#### Module 4: Masters & Product Catalog (`/items/*`, `/categories/*`, `/transporters/*`)
* **Web Features**:
  * Products (Goods) and Services inventory.
  * HSN and SAC code catalog with default GST rates (0%, 5%, 12%, 18%, 28%).
  * Units of Measurement (UOM: PCS, KGS, BOX, MTR, NOS).
  * Transporter directory (Transporter ID, TRANSIN, vehicle numbers).
* **Mobile Implementation Plan**:
  * `ItemsPage` (`lib/features/masters/presentation/pages/items_page.dart`): Products vs Services tab switch, stock status pills (In Stock, Low Stock, Out of Stock).
  * `AddItemPage`: Modern card-based input with barcode scanner integration, HSN selector, purchase/sale pricing, and opening stock.
  * `ItemCategoriesPage`: Hierarchical category grouping.
  * `TransportersPage`: E-Way Bill transporter fleet directory.

#### Module 5: Banking, Cash & Treasury (`/bank/*`, `/payments/*`)
* **Web Features**:
  * Multi-bank account tracking.
  * Inward & Outward payment receipts against bills/invoices.
  * Payment modes: UPI, NEFT/RTGS, Cheque, Cash.
* **Mobile Implementation Plan**:
  * `BankAccountsPage`: Apple Health-style horizontal card slider displaying linked bank accounts, account numbers, and live balances.
  * `BankTransactionsPage`: Searchable passbook statement with debit/credit badges.
  * `RecordPaymentPage`: Smart voucher settling multiple outstanding invoices with one tap.

#### Module 6: Expenses & Indirect Costs (`/expenses/*`)
* **Web Features**:
  * Operating and administrative expense logging.
  * Category tagging (Rent, Fuel, Utilities, Salaries, Marketing).
  * Receipt attachment and reverse charge (RCM) eligibility.
* **Mobile Implementation Plan**:
  * `ExpensesPage`: Monthly expense breakdown with visual category percentage bar.
  * `AddExpensePage`: Quick expense voucher with receipt photo attachment and GST claimable toggle.

#### Module 7: GST Compliance & Filing Desk (`/gst/*`)
* **Web Features**:
  * GSTR-1 summary table (B2B 4A, B2C 5A/7, CDNR 9B, HSN 12).
  * GSTR-3B monthly return preview (Table 3.1 Outward, Table 4 ITC, Table 5.1 Interest).
  * GSTR-2B vs Purchase Register 3-way reconciliation engine.
* **Mobile Implementation Plan**:
  * `Gstr1Page`: Card-based filing summary with status indicators and JSON export trigger.
  * `Gstr3bPage`: Month-wise tax liability vs eligible ITC calculation cards.
  * `Gstr2bReconcilePage`: Interactive reconciliation meter (% matched, mismatched, missing) with one-click WhatsApp reminder to vendors.

#### Module 8: Financial Reports & Ledgers (`/reports/*`)
* **Web Features**:
  * Trading, Profit & Loss Statement (Gross Profit, Operating Profit, Net Profit).
  * Balance Sheet (Assets, Liabilities & Owner's Equity).
  * Party Ledger / Customer & Vendor Daybook.
* **Mobile Implementation Plan**:
  * `ProfitLossPage`: Modern multi-level accordion report matching the dashboard's financial palette.
  * `BalanceSheetPage`: Clear split between Assets and Liabilities with expandable sub-schedules.
  * `PartyLedgerPage`: Date-range ledger statement with instant PDF generation and WhatsApp share.

#### Module 9: Settings, Profile & Multi-Company (`/settings/*`)
* **Web Features**:
  * Company profile (Legal name, Trade name, GSTIN, State code, Registered address).
  * Invoice customization (Custom prefix, number series, terms, bank QR code).
  * User credentials, security, and WhatsApp notification preferences.
  * API subscription and wallet balance for GST portal lookups.
* **Mobile Implementation Plan**:
  * `ProfileSettingsPage`: User credentials, security, avatar, theme toggle.
  * `CompanySettingsPage`: Legal business records, registered office, GSTIN verification badge.
  * `InvoiceSettingsPage`: Live invoice preview with customizable template toggles, prefixes, and terms.
  * `SubscriptionPage`: Active plan details, billing renewal, and API credit counter.

---

### 3. Dual-Tab Authentication Model (`Client` vs `Partner`)

Both **Login** and **Registration** will feature an integrated, high-contrast segmented control at the top of the screen:

```
┌──────────────────────────────────────────────┐
│  [        Client        ] [     Partner    ] │
└──────────────────────────────────────────────┘
```

#### A. Login Experience (`LoginPage`)
* **Tab 1: Client Login**:
  * Designed for business owners, traders, and individual entrepreneurs.
  * Credentials: Registered Email or 10-digit Mobile + Password.
  * Quick Action: WhatsApp OTP Login & Google Sign-In.
* **Tab 2: Partner Login**:
  * Designed for CAs, Tax Practitioners, Advocates, and Tax Consultants.
  * Dedicated "Partner Access Portal" badge.
  * Credentials: Registered Partner Email / Membership No. + Password (or Firm PIN).
  * Direct action link: "Join GSTSOF Partner Network".

#### B. Registration Experience (`RegisterPage`)
* **Tab 1: Client Registration**:
  * Multi-step guided wizard:
    * Step 1: Registered (15-character GSTIN lookup with live Digital ID Card preview) or Unregistered (PAN).
    * Step 2: Account credentials (Email, 10-digit WhatsApp phone, password with strength meter).
    * WhatsApp OTP Verification: Dedicated 6-digit screen with 60s cooldown timer.
* **Tab 2: Partner Registration**:
  * Professional credential verification:
    * Profession Chips: `Chartered Accountant (CA)`, `Tax Practitioner (ITP/STP)`, `Advocate`, `Accounting Professional`.
    * Professional Details: Membership Number / Certificate of Practice (COP) / Bar Council ID.
    * Firm Details: Firm / Practice Name, City, State.
    * Partner Contact: Full Name, Email, WhatsApp Phone (+91 verification), Password.
    * Chained directly to WhatsApp OTP verification -> Partner onboarding.

---

### 4. Implementation Phased Roadmap

| Milestone | Phase Name | Scope & Deliverables | Status |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Dual-Tab Authentication** | • Tabbed **Client vs. Partner Login** on `LoginPage`<br/>• Tabbed **Client vs. Partner Registration** on `RegisterPage`<br/>• Centralized `StringManager` keys for all new auth labels | **✅ 100% Completed** |
| **Phase 2** | **Sales & Customer Suite** | • `CustomersPage` & modern `AddCustomerPage`<br/>• `InvoicesPage` & dynamic `CreateInvoicePage`<br/>• `CreditNotesPage` & `CreateCreditNotePage`<br/>• `DeliveryChallansPage` & `CreateDeliveryChallanPage` | **✅ 100% Completed** |
| **Phase 3** | **Purchase & Vendor Suite** | • `VendorsPage` & `AddVendorPage`<br/>• `PurchaseBillsPage` & `CreatePurchaseBillPage`<br/>• `IncomingInvoicesPage` (GSTR-2B sync)<br/>• `DebitNotesPage` & `CreateDebitNotePage` | **✅ 100% Completed** |
| **Phase 4** | **Masters & Inventory** | • `ItemsPage` (Products/Services catalog)<br/>• `AddItemPage` (HSN/SAC, tax slabs, UOM, stock)<br/>• `ItemCategoriesPage` & `AddCategoryPage`<br/>• `TransportersPage` & `AddTransporterPage` | **✅ 100% Completed** |
| **Phase 5** | **Cash, Banking & Expenses** | • `BankAccountsPage` & `AddBankAccountPage`<br/>• `BankTransactionsPage`<br/>• `RecordPaymentPage`<br/>• `ExpensesPage` & `AddExpensePage`<br/>• `IncomePage` & `AddIncomePage` | **✅ 100% Completed** |
| **Phase 6** | **GST Compliance, Reports & Settings** | • `Gstr1Page`, `Gstr3bPage`, `Gstr2bReconcilePage`<br/>• `ProfitLossPage`, `BalanceSheetPage`, `PartyLedgerPage`<br/>• `CompanySettingsPage`, `InvoiceSettingsPage`, `SubscriptionPage` | **✅ 100% Completed** |

---

### 5. Code Quality & Standards Enforcement
* **100% String Centralization**: All strings must be declared in `StringManager` (`lib/core/res/string_manager.dart`). No hardcoded UI strings.
* **Feature-Based Architecture**: Follow strict folder organization:
  `lib/features/<module>/presentation/pages/`
  `lib/features/<module>/presentation/widgets/`
  `lib/features/<module>/presentation/providers/`
* **UI Standard**: Mirror the aesthetic of `DashboardPage` (Inter typography, `ColorManager.primaryGreen`, soft rounded borders `16-24px`, card elevation shadows, and clean light/dark support).
* **Zero Analyzer Errors**: Verify `flutter analyze` passes cleanly after every milestone.

---

### [COMMIT #071] - Complete Clean Architecture Refactoring & Missing Add/Create Pages
- **Date & Time:** October 25, 2026
- **Feature Name:** `clean-architecture-add-pages-completion`
- **What Was Done:**
  - **Full Architectural Separation**: Refactored all features into strict Clean Architecture structure:
    - `features/gst/`: Provider (`gst_provider.dart`), Widgets (`gstr1_section_card.dart`, `gstr3b_table_card.dart`, `reconcile_match_meter.dart`, `reconcile_item_card.dart`), and Pages (`gstr1_page.dart`, `gstr3b_page.dart`, `gstr2b_reconcile_page.dart`).
    - `features/invoice/`: Provider (`invoice_provider.dart`), Widgets (`invoice_card.dart`, `invoice_metric_card.dart`, `credit_note_card.dart`, `delivery_challan_card.dart`), and Pages (`invoices_page.dart`, `credit_notes_page.dart`, `delivery_challans_page.dart`, `create_invoice_page.dart`, `create_credit_note_page.dart`, `create_delivery_challan_page.dart`).
    - `features/banking/`: Provider (`banking_provider.dart`), Widgets (`bank_account_card.dart`, `bank_transaction_tile.dart`, `expense_card.dart`, `income_card.dart`), and Pages (`bank_accounts_page.dart`, `add_bank_account_page.dart`, `bank_transactions_page.dart`, `record_payment_page.dart`, `expenses_page.dart`, `add_expense_page.dart`, `income_page.dart`, `add_income_page.dart`).
    - `features/masters/`: Provider (`masters_provider.dart`), Widgets (`item_card.dart`, `category_card.dart`, `transporter_card.dart`), and Pages (`items_page.dart`, `add_item_page.dart`, `item_categories_page.dart`, `add_category_page.dart`, `transporters_page.dart`, `add_transporter_page.dart`).
    - `features/purchase/`: Provider (`purchase_provider.dart`), Widgets (`vendor_card.dart`, `purchase_bill_card.dart`, `incoming_invoice_card.dart`, `debit_note_card.dart`), and Pages (`vendors_page.dart`, `add_vendor_page.dart`, `purchase_bills_page.dart`, `create_purchase_bill_page.dart`, `incoming_invoices_page.dart`, `debit_notes_page.dart`, `create_debit_note_page.dart`).
  - **Implemented Complete Set of Missing Add/Create Form Pages** based on live GSTSOF web portal fields:
    - `AddCategoryPage`: Category/Group Name, Parent Category dropdown, Default HSN/SAC, Default Tax Slab, Description, Active status switch.
    - `AddTransporterPage`: Transporter Name, 15-char TRANSIN/GSTIN, Vehicle Number, Contact Person, Phone, Email, Office Address, City, State, Pincode.
    - `AddExpensePage`: Expense Category, Payee/Vendor, Amount, Date, Paid Through Mode, Bank Account selection, GST Taxable Expense toggle, ITC Eligible toggle, Voucher/Bill number, Narration notes.
    - `AddIncomePage`: Income Category, Payer/Client Name, Amount, Date, Deposit Into Account, Receipt Mode, Transaction Ref ID, Remarks.
    - `AddBankAccountPage`: Account Display Name, Bank Name, Account Type (Current, Savings, OD, Escrow), Account Number & Confirmation check, IFSC with branch autofill, Opening balance, Primary account toggle.
    - `CreateCreditNotePage`: Customer dropdown, Credit Note No., Original Invoice No. & Date, Reason for Credit Note (Sales return, Discount, Deficiency, etc.), Credit value, Tax slab, Adjustment mode.
    - `CreateDeliveryChallanPage`: Challan No. & Date, Consignee name & GSTIN, Dispatch & Delivery addresses, Purpose of transportation (Job work, supply on approval, exhibition, etc.), Vehicle No., Transporter name, Goods description, Approximate value, E-Way Bill toggle.
    - `CreatePurchaseBillPage`: Vendor dropdown, Supplier Bill No. & Date, Place of supply, Payment due date, Goods description, Taxable amount, GST slab, ITC eligibility classification, RCM toggle.
    - `CreateDebitNotePage`: Vendor dropdown, Debit Note No., Original Bill No. & Date, Reason for debit note, Debit taxable value, GST slab, ITC reversal toggle (Sec 16(2)).
  - **Wiring & Routing**:
    - Wired all 9 new routes in `AppRouter` (`lib/core/router/app_router.dart`).
    - Updated Floating Action Buttons across `item_categories_page.dart`, `transporters_page.dart`, `expenses_page.dart`, `income_page.dart`, `bank_accounts_page.dart`, `credit_notes_page.dart`, `delivery_challans_page.dart`, `purchase_bills_page.dart`, and `debit_notes_page.dart` to navigate directly to their respective Add/Create forms.
  - **String Centralization**: 100% of newly introduced user-facing labels and field headers added to `StringManager`.
  - **Static Analysis**: Verified with `dart analyze lib` -> **No issues found! (0 warnings, 0 errors)**.

---

### [COMMIT #072] - Manage Expenses Exact Web Parity Alignment
- **Date & Time:** October 25, 2026
- **Feature Name:** `manage-expenses-web-parity`
- **What Was Done:**
  - **Exact Alignment with Live Web Screenshot (`Manage Expenses`)**:
    - **Header & Title**: Updated page title to `Manage Expenses` with blue `Refresh` button in the AppBar.
    - **Complete Search & Filter Bar**:
      - `Show [ 50 v ]` dropdown selector (10, 25, 50, 100).
      - `Start Date` & `End Date` inputs with green magnifying glass search button.
      - `Search By` dropdown (`Expense No.`, `Party`, `Category`).
      - Keyword search field with magnifying glass.
    - **Dual Tab Architecture**:
      - Tab 1: **Category** with geometric category icon (`Icons.category_outlined`).
      - Tab 2: **Item** with list bullet icon (`Icons.list_alt_rounded`).
    - **Web Header Card Banner**:
      - Green box icon container.
      - Dynamic titles: **Expense Items** vs. **Expense Categories** with web subtitles.
      - Action CTA: **Choose Item** (navigates to `AddExpensePage`) vs. **Add Category** (navigates to `AddCategoryPage`).
    - **Table Columns & Data Fields**:
      - `Expense Items`: `SL. No`, `Action`, `Date`, `EXP No.`, `Party`, `Payment Mode`, `Amount`, `Due Date`, `GST Claimable` badge.
      - `Expense Categories`: `SL. No`, `Category Name`, `Description`, `Status` badge (`Active`), `Action`.
      - Empty state matches web: `No record found.`.
  - **Provider & Model Upgrades**:
    - `ExpenseModel` updated with `slNo`, `expNo`, `date`, `party`, `paymentMode`, `amount`, `dueDate`, `category`, `gstClaimable`.
    - Added `ExpenseCategoryModel` with `slNo`, `name`, `description`, `status`, `isActive`.
    - Reactive state providers: `expenseSelectedTabProvider`, `expenseEntriesPerPageProvider`, `expenseStartDateProvider`, `expenseEndDateProvider`, `expenseSearchByProvider`, `expenseSearchQueryProvider`.
    - Separate filtered providers: `filteredExpensesProvider`, `filteredExpenseCategoriesProvider`.
  - **Form Fidelity in `AddExpensePage`**:
    - Added `EXP No.` and `Due Date` fields to match table columns.
  - **Static Analysis**: `dart analyze lib` passes with **0 warnings, 0 errors, 0 hints**.

---

### [COMMIT #073] - Universal Web Portal Parity Across All Modules
- **Date & Time:** October 25, 2026
- **Feature Name:** `universal-web-portal-parity`
- **What Was Done:**
  - **Universal 5-Tier Web UI Architecture**:
    - Standardized all entity listing screens to match the exact 5-tier web layout established in the GSTSOF web portal screenshot:
      1. Top Bar: Screen Title + Blue `[ Refresh ]` button (`WebRefreshButton`).
      2. Filter & Pagination Toolbar: `Show [ 50 v ]`, `Start Date`, `End Date`, Green Search `[ Q ]`, `Search By` dropdown, search input (`WebFilterToolbar`).
      3. Dual Tabs: For modules supporting dual views (e.g. `ItemsPage`: `[ Category ]` vs `[ Item ]`, `ExpensesPage`: `[ Category ]` vs `[ Item ]`).
      4. Section Header Card Banner: Green icon box + Bold Entity Title + Subtitle *"Manage your [entity], view details and take action."* + Primary Action button (`WebSectionBanner`).
      5. High-density data table cards + Centered empty state *"No record found."* (`WebEmptyState`).
  - **Reusable Web Presentation Widgets Created**:
    - `lib/core/widgets/web_filter_toolbar.dart`: Unified reactive filter bar with per-page dropdown, date range, search by, and keyword search.
    - `lib/core/widgets/web_section_banner.dart`: Unified green branded section header card.
    - `lib/core/widgets/web_refresh_button.dart`: Branded blue `#2563EB` sync action button.
    - `lib/core/widgets/web_empty_state.dart`: Standardized empty state card.
  - **Module Upgrades & Clean Architecture Refactoring**:
    - **Sales & Invoicing Module (`lib/features/invoice`)**:
      - `InvoiceModel`, `CreditNoteModel`, `DeliveryChallanModel` updated with exact web fields (`slNo`, `date`, `party`, `taxableAmount`, `totalTax`, `amount`, `status`, `dueDate`).
      - Refactored `InvoicesPage`, `CreditNotesPage`, and `DeliveryChallansPage` to the 5-tier web architecture.
      - Refactored `InvoiceCard` with 8-column web metadata grid.
    - **Customer & Parties Module (`lib/features/customer`)**:
      - Refactored monolithic `customers_page.dart` into Clean Architecture separation (`customer_provider.dart`, `customer_card.dart`, `customers_page.dart`).
      - `CustomerModel` updated with `slNo`, `customerName`, `companyName`, `gstin`, `mobile`, `email`, `state`, `type` (`B2B`/`B2C`), `outstandingBalance`, `status`.
    - **Purchase Module (`lib/features/purchase`)**:
      - `PurchaseBillModel`, `VendorModel`, `DebitNoteModel` updated with exact web fields (`slNo`, `billNo`, `gstin`, `taxableValue`, `totalTax`, `amount`, `itcStatus`, `dueDate`).
      - Refactored `PurchaseBillsPage`, `VendorsPage`, and `DebitNotesPage` to the 5-tier web architecture.
      - Refactored `PurchaseBillCard`, `VendorCard`, and `DebitNoteCard`.
    - **Masters & Inventory Module (`lib/features/masters`)**:
      - Refactored `ItemsPage` into a dual-tab layout (`[ Category ]` vs `[ Item ]`) matching the web portal standard with dynamic section banners.
      - `ItemModel` updated with `slNo`, `sku`, `hsn`, `category`, `unit`, `salePrice`, `purchasePrice`, `taxRate`, `stock`.
      - Refactored `TransportersPage` with web filter toolbar and section banner.
    - **Banking Module (`lib/features/banking`)**:
      - `BankTransactionModel` updated with `slNo`, `title`, `accountName`, `mode`, `date`, `ref`, `party`, `amount`, `balance`, `isCredit`, `status`.
      - Refactored `BankTransactionsPage` and `BankAccountsPage` to the 5-tier web architecture.
  - **String Centralization**: 100% user-facing strings centralized in `lib/core/res/string_manager.dart`.
  - **Static Analysis Verification**: `dart analyze lib` passed with **0 errors, 0 warnings, 0 issues found!**
