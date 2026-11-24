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
import '../providers/invoice_provider.dart';
import '../widgets/delivery_challan_card.dart';

/// Modern Delivery Challans Page matching the GSTSOF web portal design:
/// - Screen title: Delivery Challans
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Challan No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Delivery Challans", subtitle, action button: "+ Create Delivery Challan"
/// - Table list with exact web fields: SL. No, Action, Date, Challan No., Consignee Name, Vehicle No., Goods Type, Approximate Value, Status
class DeliveryChallansPage extends ConsumerWidget {
  const DeliveryChallansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final challans = ref.watch(filteredDeliveryChallansProvider);
    final entriesPerPage = ref.watch(challanEntriesPerPageProvider);
    final searchBy = ref.watch(challanSearchByProvider);
    final searchQuery = ref.watch(challanSearchQueryProvider);
    final startDate = ref.watch(challanStartDateProvider);
    final endDate = ref.watch(challanEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.deliveryChallans,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing delivery challans...'),
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
                if (val != null) ref.read(challanEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(challanStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(challanEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying challan date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Challan No.', 'Consignee', 'Vehicle No.'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(challanSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(challanSearchQueryProvider.notifier).state = val,
              searchHint: 'Search challans...',
            ),

            WebSectionBanner(
              icon: Icons.local_shipping_rounded,
              title: StringManager.deliveryChallans,
              subtitle: StringManager.deliveryChallansSubtitle,
              actionLabel: StringManager.createDeliveryChallan,
              onActionPressed: () => context.push(AppRouter.createDeliveryChallan),
            ),

            Expanded(
              child: challans.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: challans.length,
                      itemBuilder: (context, index) {
                        return DeliveryChallanCard(challan: challans[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
