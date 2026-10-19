import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';

/// Full-screen immersive Onboarding / Story View Page showcasing the app's actual menu offerings.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Masters & Inventory Hub',
      subtitle: 'Manage Item Groups, Categories, Item Lists, and Transporters in one centralized master database with lightning-fast search and complete customization.',
      icon: Icons.folder_rounded,
      accentColor: const Color(0xFF059669),
    ),
    OnboardingItem(
      title: 'Sales & E-Way Invoicing',
      subtitle: 'Create Tax Invoices, manage Customers, generate Credit Notes/Sales Returns & Delivery Challans instantly with full GST compliance.',
      icon: Icons.sell_rounded,
      accentColor: const Color(0xFFF97316),
    ),
    OnboardingItem(
      title: 'Purchase & Expense Tracking',
      subtitle: 'Track Vendors, Purchase Invoices, Incoming Bills, Debit Notes, and monitor your day-to-day business Expenses & Income effortlessly.',
      icon: Icons.shopping_cart_rounded,
      accentColor: Colors.blue,
    ),
    OnboardingItem(
      title: 'GST Reports & Compliance',
      subtitle: 'Generate accurate GSTR-1, GSTR-3B returns, Profit & Loss statements, and Balance Sheet financial reports at your fingertips.',
      icon: Icons.bar_chart_rounded,
      accentColor: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkSurface : const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Brand Header & Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset('assets/png_images/logo_icon.png', width: 24, height: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GSTSOF',
                        style: getBoldStyle(
                          fontSize: FontManager.s18,
                          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRouter.login),
                    child: Text(
                      'Skip',
                      style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Full-Screen PageView Story View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Large Full-Screen Illustration Container
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: item.accentColor.withValues(alpha: 0.2),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(item.icon, size: 56, color: item.accentColor),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontSize: FontManager.s24,
                            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontManager.s15,
                            fontFamily: 'Inter',
                            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Paginator & Navigation Row
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? ColorManager.primaryGreen : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
