import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../features/banking/presentation/pages/add_bank_account_page.dart';
import '../../features/banking/presentation/pages/add_expense_page.dart';
import '../../features/banking/presentation/pages/add_income_page.dart';
import '../../features/banking/presentation/pages/bank_accounts_page.dart';
import '../../features/banking/presentation/pages/bank_transactions_page.dart';
import '../../features/banking/presentation/pages/expenses_page.dart';
import '../../features/banking/presentation/pages/income_page.dart';
import '../../features/banking/presentation/pages/record_payment_page.dart';
import '../../features/customer/presentation/pages/add_customer_page.dart';
import '../../features/customer/presentation/pages/customers_page.dart';
import '../../features/dashboard/presentation/pages/main_dashboard_layout.dart';
import '../../features/gst/presentation/pages/gstr1_page.dart';
import '../../features/gst/presentation/pages/gstr2b_reconcile_page.dart';
import '../../features/gst/presentation/pages/gstr3b_page.dart';
import '../../features/invoice/presentation/pages/create_credit_note_page.dart';
import '../../features/invoice/presentation/pages/create_delivery_challan_page.dart';
import '../../features/invoice/presentation/pages/create_invoice_page.dart';
import '../../features/invoice/presentation/pages/credit_notes_page.dart';
import '../../features/invoice/presentation/pages/delivery_challans_page.dart';
import '../../features/invoice/presentation/pages/invoices_page.dart';
import '../../features/masters/presentation/pages/add_category_page.dart';
import '../../features/masters/presentation/pages/add_item_page.dart';
import '../../features/masters/presentation/pages/add_transporter_page.dart';
import '../../features/masters/presentation/pages/item_categories_page.dart';
import '../../features/masters/presentation/pages/items_page.dart';
import '../../features/masters/presentation/pages/transporters_page.dart';
import '../../features/profile/presentation/pages/company_settings_page.dart';
import '../../features/profile/presentation/pages/invoice_settings_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/profile_settings_page.dart';
import '../../features/profile/presentation/pages/subscription_page.dart';
import '../../features/purchase/presentation/pages/add_vendor_page.dart';
import '../../features/purchase/presentation/pages/create_debit_note_page.dart';
import '../../features/purchase/presentation/pages/create_purchase_bill_page.dart';
import '../../features/purchase/presentation/pages/debit_notes_page.dart';
import '../../features/purchase/presentation/pages/incoming_invoices_page.dart';
import '../../features/purchase/presentation/pages/purchase_bills_page.dart';
import '../../features/purchase/presentation/pages/vendors_page.dart';
import '../../features/reports/presentation/pages/balance_sheet_page.dart';
import '../../features/reports/presentation/pages/party_ledger_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';

/// GoRouter configuration for declarative routing and navigation across the entire app.
class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/';
  static const String register = '/register';
  static const String verifyOtp = '/verify_otp';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String profileSettings = '/profile_settings';
  static const String companySettings = '/company_settings';
  static const String invoiceSettings = '/invoice_settings';
  static const String subscription = '/subscription';

  // Sales & Customers
  static const String customers = '/customers';
  static const String addCustomer = '/add_customer';
  static const String invoices = '/invoices';
  static const String createInvoice = '/create_invoice';
  static const String creditNotes = '/credit_notes';
  static const String createCreditNote = '/create_credit_note';
  static const String deliveryChallans = '/delivery_challans';
  static const String createDeliveryChallan = '/create_delivery_challan';

  // Purchases & Vendors
  static const String vendors = '/vendors';
  static const String addVendor = '/add_vendor';
  static const String purchaseInvoices = '/purchase_invoices';
  static const String createPurchaseBill = '/create_purchase_bill';
  static const String incomingInvoices = '/incoming_invoices';
  static const String debitNotes = '/debit_notes';
  static const String createDebitNote = '/create_debit_note';

  // Masters
  static const String items = '/items';
  static const String addItem = '/add_item';
  static const String itemCategories = '/item_categories';
  static const String addCategory = '/add_category';
  static const String transporters = '/transporters';
  static const String addTransporter = '/add_transporter';

  // Banking & Expenses
  static const String bankAccounts = '/bank_accounts';
  static const String addBankAccount = '/add_bank_account';
  static const String bankTransactions = '/bank_transactions';
  static const String recordPayment = '/record_payment';
  static const String expenses = '/expenses';
  static const String addExpense = '/add_expense';
  static const String income = '/income';
  static const String addIncome = '/add_income';

  // GST & Reports
  static const String gstr1 = '/gstr1';
  static const String gstr3b = '/gstr3b';
  static const String gstr2bReconcile = '/gstr2b_reconcile';
  static const String profitLoss = '/profit_loss';
  static const String balanceSheet = '/balance_sheet';
  static const String partyLedger = '/party_ledger';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => RegisterPage(
          initialRole: state.extra as String?,
        ),
      ),
      GoRoute(
        path: verifyOtp,
        name: 'verify_otp',
        builder: (context, state) => const VerifyOtpPage(),
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const MainDashboardLayout(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: profileSettings,
        name: 'profile_settings',
        builder: (context, state) => const ProfileSettingsPage(),
      ),
      GoRoute(
        path: companySettings,
        name: 'company_settings',
        builder: (context, state) => const CompanySettingsPage(),
      ),
      GoRoute(
        path: invoiceSettings,
        name: 'invoice_settings',
        builder: (context, state) => const InvoiceSettingsPage(),
      ),
      GoRoute(
        path: subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionPage(),
      ),

      // Sales & Customer Suite
      GoRoute(
        path: customers,
        name: 'customers',
        builder: (context, state) => const CustomersPage(),
      ),
      GoRoute(
        path: addCustomer,
        name: 'add_customer',
        builder: (context, state) => const AddCustomerPage(),
      ),
      GoRoute(
        path: invoices,
        name: 'invoices',
        builder: (context, state) => const InvoicesPage(),
      ),
      GoRoute(
        path: createInvoice,
        name: 'create_invoice',
        builder: (context, state) => const CreateInvoicePage(),
      ),
      GoRoute(
        path: creditNotes,
        name: 'credit_notes',
        builder: (context, state) => const CreditNotesPage(),
      ),
      GoRoute(
        path: createCreditNote,
        name: 'create_credit_note',
        builder: (context, state) => const CreateCreditNotePage(),
      ),
      GoRoute(
        path: deliveryChallans,
        name: 'delivery_challans',
        builder: (context, state) => const DeliveryChallansPage(),
      ),
      GoRoute(
        path: createDeliveryChallan,
        name: 'create_delivery_challan',
        builder: (context, state) => const CreateDeliveryChallanPage(),
      ),

      // Purchase & Vendor Suite
      GoRoute(
        path: vendors,
        name: 'vendors',
        builder: (context, state) => const VendorsPage(),
      ),
      GoRoute(
        path: addVendor,
        name: 'add_vendor',
        builder: (context, state) => const AddVendorPage(),
      ),
      GoRoute(
        path: purchaseInvoices,
        name: 'purchase_invoices',
        builder: (context, state) => const PurchaseBillsPage(),
      ),
      GoRoute(
        path: createPurchaseBill,
        name: 'create_purchase_bill',
        builder: (context, state) => const CreatePurchaseBillPage(),
      ),
      GoRoute(
        path: incomingInvoices,
        name: 'incoming_invoices',
        builder: (context, state) => const IncomingInvoicesPage(),
      ),
      GoRoute(
        path: debitNotes,
        name: 'debit_notes',
        builder: (context, state) => const DebitNotesPage(),
      ),
      GoRoute(
        path: createDebitNote,
        name: 'create_debit_note',
        builder: (context, state) => const CreateDebitNotePage(),
      ),

      // Masters
      GoRoute(
        path: items,
        name: 'items',
        builder: (context, state) => const ItemsPage(),
      ),
      GoRoute(
        path: addItem,
        name: 'add_item',
        builder: (context, state) => const AddItemPage(),
      ),
      GoRoute(
        path: itemCategories,
        name: 'item_categories',
        builder: (context, state) => const ItemCategoriesPage(),
      ),
      GoRoute(
        path: addCategory,
        name: 'add_category',
        builder: (context, state) => const AddCategoryPage(),
      ),
      GoRoute(
        path: transporters,
        name: 'transporters',
        builder: (context, state) => const TransportersPage(),
      ),
      GoRoute(
        path: addTransporter,
        name: 'add_transporter',
        builder: (context, state) => const AddTransporterPage(),
      ),

      // Banking & Expenses
      GoRoute(
        path: bankAccounts,
        name: 'bank_accounts',
        builder: (context, state) => const BankAccountsPage(),
      ),
      GoRoute(
        path: addBankAccount,
        name: 'add_bank_account',
        builder: (context, state) => const AddBankAccountPage(),
      ),
      GoRoute(
        path: bankTransactions,
        name: 'bank_transactions',
        builder: (context, state) => const BankTransactionsPage(),
      ),
      GoRoute(
        path: recordPayment,
        name: 'record_payment',
        builder: (context, state) => const RecordPaymentPage(),
      ),
      GoRoute(
        path: expenses,
        name: 'expenses',
        builder: (context, state) => const ExpensesPage(),
      ),
      GoRoute(
        path: addExpense,
        name: 'add_expense',
        builder: (context, state) => const AddExpensePage(),
      ),
      GoRoute(
        path: income,
        name: 'income',
        builder: (context, state) => const IncomePage(),
      ),
      GoRoute(
        path: addIncome,
        name: 'add_income',
        builder: (context, state) => const AddIncomePage(),
      ),

      // GST & Reports
      GoRoute(
        path: gstr1,
        name: 'gstr1',
        builder: (context, state) => const Gstr1Page(),
      ),
      GoRoute(
        path: gstr3b,
        name: 'gstr3b',
        builder: (context, state) => const Gstr3bPage(),
      ),
      GoRoute(
        path: gstr2bReconcile,
        name: 'gstr2b_reconcile',
        builder: (context, state) => const Gstr2bReconcilePage(),
      ),
      GoRoute(
        path: profitLoss,
        name: 'profit_loss',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: balanceSheet,
        name: 'balance_sheet',
        builder: (context, state) => const BalanceSheetPage(),
      ),
      GoRoute(
        path: partyLedger,
        name: 'party_ledger',
        builder: (context, state) => const PartyLedgerPage(),
      ),
    ],
  );
}
