import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../customer/presentation/pages/customers_page.dart';
import '../../../invoice/presentation/pages/invoices_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../widgets/menu_bottom_sheet.dart';
import '../widgets/modern_bottom_nav_bar.dart';
import 'dashboard_page.dart';

/// Modern Navbar layout matching user specifications:
/// Index 0: Report (ReportsPage)
/// Index 1: Invoices (InvoicesPage)
/// Index 2: Home (DashboardPage, default active screen)
/// Index 3: Customer (CustomersPage)
/// Index 4: More (opens MenuBottomSheet)
class MainDashboardLayout extends ConsumerStatefulWidget {
  const MainDashboardLayout({super.key});

  @override
  ConsumerState<MainDashboardLayout> createState() => _MainDashboardLayoutState();
}

class _MainDashboardLayoutState extends ConsumerState<MainDashboardLayout> {
  // Index 2 is Home in the center of the bottom navigation bar
  int _currentIndex = 2;

  final List<Widget> _pages = const [
    ReportsPage(),   // 0: Report with Report icon
    InvoicesPage(),  // 1: Invoices
    DashboardPage(), // 2: Home nav populates DashboardPage
    CustomersPage(), // 3: Customer with Customer icon
  ];

  void _onTabTapped(int index) {
    if (index == 4) {
      // Open Menu Bottom Sheet when tapping 'More'
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const FractionallySizedBox(
          heightFactor: 0.8,
          child: MenuBottomSheet(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex > 3 ? 2 : _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
