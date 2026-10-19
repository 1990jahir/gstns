import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/incoming_invoices_tab.dart';
import '../widgets/purchase_invoices_tab.dart';

/// Professional Invoices Page with two tabs (Purchase Invoice & Incoming Invoice).
class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({super.key});

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Manage Invoices',
          style: getBoldStyle(
            fontSize: FontManager.s20,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorManager.primaryGreen,
          unselectedLabelColor: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
          indicatorColor: ColorManager.primaryGreen,
          labelStyle: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
          unselectedLabelStyle: getMediumStyle(fontSize: FontManager.s14, color: ColorManager.grey),
          tabs: const [
            Tab(text: 'Purchase Invoices'),
            Tab(text: 'Incoming Invoices'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            PurchaseInvoicesTab(),
            IncomingInvoicesTab(),
          ],
        ),
      ),
    );
  }
}
