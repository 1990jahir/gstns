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
import '../widgets/vendor_card.dart';

/// Modern Manage Vendors Page matching the GSTSOF web portal design:
/// - Screen title: Manage Vendors
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Vendor Name v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Vendors Directory", subtitle, action button: "+ Add Vendor"
/// - Table list with exact web fields: SL. No, Action, Vendor Name, GSTIN, Phone/Mobile, Email, State, Payable Balance, Status
class VendorsPage extends ConsumerWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vendors = ref.watch(filteredVendorsProvider);
    final entriesPerPage = ref.watch(vendorEntriesPerPageProvider);
    final searchBy = ref.watch(vendorSearchByProvider);
    final searchQuery = ref.watch(vendorSearchQueryProvider);
    final startDate = ref.watch(vendorStartDateProvider);
    final endDate = ref.watch(vendorEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.manageVendors,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing vendors...'),
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
                if (val != null) ref.read(vendorEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(vendorStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(vendorEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying vendor date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Vendor Name', 'GSTIN', 'Phone'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(vendorSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(vendorSearchQueryProvider.notifier).state = val,
              searchHint: 'Search vendors...',
            ),

            WebSectionBanner(
              icon: Icons.storefront_rounded,
              title: 'Vendors Directory',
              subtitle: StringManager.vendorsSubtitle,
              actionLabel: StringManager.addVendor,
              onActionPressed: () => context.push(AppRouter.addVendor),
            ),

            Expanded(
              child: vendors.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        return VendorCard(vendor: vendors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
