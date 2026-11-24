import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/web_empty_state.dart';
import '../../../../core/widgets/web_filter_toolbar.dart';
import '../../../../core/widgets/web_refresh_button.dart';
import '../../../../core/widgets/web_section_banner.dart';
import '../providers/purchase_provider.dart';
import '../widgets/purchase_bill_card.dart';

/// Modern Purchase Bills Page matching the GSTSOF web portal design:
/// - Screen title: Manage Purchases
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Bill No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Purchase Bills", subtitle, action button: "+ Record Bill"
/// - Table list with exact web fields: SL. No, Action, Date, Bill No., Vendor Name, GSTIN, Taxable Value, Total Tax, Total Amount, ITC Status, Due Date
class PurchaseBillsPage extends ConsumerWidget {
  const PurchaseBillsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bills = ref.watch(filteredPurchaseBillsProvider);
    final entriesPerPage = ref.watch(purchaseEntriesPerPageProvider);
    final searchBy = ref.watch(purchaseSearchByProvider);
    final searchQuery = ref.watch(purchaseSearchQueryProvider);
    final startDate = ref.watch(purchaseStartDateProvider);
    final endDate = ref.watch(purchaseEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.managePurchases,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing purchase bills...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            WebFilterToolbar(
              entriesPerPage: entriesPerPage,
              onEntriesPerPageChanged: (val) {
                if (val != null) ref.read(purchaseEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(purchaseStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(purchaseEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying purchase date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Bill No.', 'Vendor Name', 'GSTIN'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(purchaseSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(purchaseSearchQueryProvider.notifier).state = val,
              searchHint: 'Search purchase bills...',
            ),

            WebSectionBanner(
              icon: Icons.shopping_cart_checkout_rounded,
              title: 'Purchase Bills',
              subtitle: StringManager.purchasesSubtitle,
              actionLabel: StringManager.createPurchase,
              onActionPressed: () => context.push(AppRouter.createPurchaseBill),
            ),

            Expanded(
              child: bills.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: bills.length,
                      itemBuilder: (context, index) {
                        return PurchaseBillCard(bill: bills[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
