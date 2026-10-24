import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/customer/presentation/pages/add_customer_page.dart';
import '../../features/dashboard/presentation/pages/main_dashboard_layout.dart';
import '../../features/invoice/presentation/pages/create_invoice_page.dart';
import '../../features/profile/presentation/pages/company_settings_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// GoRouter configuration for declarative routing and navigation across the app.
class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String addCustomer = '/add_customer';
  static const String createInvoice = '/create_invoice';
  static const String companySettings = '/company_settings';

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
        builder: (context, state) => const RegisterPage(),
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
        path: addCustomer,
        name: 'add_customer',
        builder: (context, state) => const AddCustomerPage(),
      ),
      GoRoute(
        path: createInvoice,
        name: 'create_invoice',
        builder: (context, state) => const CreateInvoicePage(),
      ),
      GoRoute(
        path: companySettings,
        name: 'company_settings',
        builder: (context, state) => const CompanySettingsPage(),
      ),
    ],
  );
}
