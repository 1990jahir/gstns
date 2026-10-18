import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// GoRouter configuration for declarative routing and navigation across the app.
class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
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
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
