import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/menu_bottom_sheet.dart';
import '../widgets/modern_bottom_nav_bar.dart';
import 'dashboard_page.dart';

/// Modern UI Navbar-based layout integrating Dashboard, Invoices, Reports, Profile, and Menu sheet.
class MainDashboardLayout extends ConsumerStatefulWidget {
  const MainDashboardLayout({super.key});

  @override
  ConsumerState<MainDashboardLayout> createState() => _MainDashboardLayoutState();
}

class _MainDashboardLayoutState extends ConsumerState<MainDashboardLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    Center(child: Text('Invoices Module')),
    Center(child: Text('Reports Module')),
    ProfilePage(), // Profile page integrated directly into bottom navbar index 3
  ];

  void _onTabTapped(int index) {
    if (index == 4) {
      // Open Menu Bottom Sheet with curved top corners when tapping 'Menu'
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
      extendBody: true, // Allows content to flow behind floating bottom nav bar
      body: IndexedStack(
        index: _currentIndex > 3 ? 0 : _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
