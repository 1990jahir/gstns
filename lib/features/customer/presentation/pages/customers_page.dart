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
import '../providers/customer_provider.dart';
import '../widgets/customer_card.dart';

/// Modern Manage Customers Page matching the GSTSOF web portal design:
/// - Screen title: Manage Customers
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Customer Name v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Customers Directory", subtitle, action button: "+ Add Customer"
/// - Table list with exact web fields: SL. No, Action, Customer Name, GSTIN/UIN, Mobile No., Email, City/State, Outstanding Balance, Status
class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customers = ref.watch(filteredCustomersProvider);
    final entriesPerPage = ref.watch(customerEntriesPerPageProvider);
    final searchBy = ref.watch(customerSearchByProvider);
    final searchQuery = ref.watch(customerSearchQueryProvider);
    final startDate = ref.watch(customerStartDateProvider);
    final endDate = ref.watch(customerEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.manageCustomers,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing customers from server...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Filter Toolbar: Show [50], Start Date, End Date, Search By, Search Input
            WebFilterToolbar(
              entriesPerPage: entriesPerPage,
              onEntriesPerPageChanged: (val) {
                if (val != null) ref.read(customerEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(customerStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(customerEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying customer date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Customer Name', 'GSTIN', 'Mobile'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(customerSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(customerSearchQueryProvider.notifier).state = val,
              searchHint: 'Search customers...',
            ),

            // Green Box Section Header Banner
            WebSectionBanner(
              icon: Icons.people_alt_rounded,
              title: 'Customers Directory',
              subtitle: StringManager.customersSubtitle,
              actionLabel: StringManager.addCustomer,
              onActionPressed: () => context.push(AppRouter.addCustomer),
            ),

            // Customer List or Empty State
            Expanded(
              child: customers.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        return CustomerCard(customer: customers[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
