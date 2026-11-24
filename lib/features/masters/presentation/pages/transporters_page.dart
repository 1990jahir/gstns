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
import '../providers/masters_provider.dart';
import '../widgets/transporter_card.dart';

/// Modern Transporters Page matching the GSTSOF web portal design:
/// - Screen title: Transporters
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Transporter Name v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Transporters", subtitle, action button: "+ Add Transporter"
/// - Table list with exact web fields: SL. No, Action, Transporter Name, Transporter ID, Contact Person, Phone, Active Vehicles, Status
class TransportersPage extends ConsumerWidget {
  const TransportersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transporters = ref.watch(filteredTransportersProvider);
    final entriesPerPage = ref.watch(transporterEntriesPerPageProvider);
    final searchBy = ref.watch(transporterSearchByProvider);
    final searchQuery = ref.watch(transporterSearchQueryProvider);
    final startDate = ref.watch(transporterStartDateProvider);
    final endDate = ref.watch(transporterEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.transporters,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing transporters...'),
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
                if (val != null) ref.read(transporterEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(transporterStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(transporterEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying transporter date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Transporter Name', 'Transporter ID', 'Phone'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(transporterSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(transporterSearchQueryProvider.notifier).state = val,
              searchHint: 'Search transporters...',
            ),

            WebSectionBanner(
              icon: Icons.fire_truck_rounded,
              title: StringManager.transporters,
              subtitle: StringManager.transportersSubtitle,
              actionLabel: StringManager.addTransporter,
              onActionPressed: () => context.push(AppRouter.addTransporter),
            ),

            Expanded(
              child: transporters.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: transporters.length,
                      itemBuilder: (context, index) {
                        return TransporterCard(transporter: transporters[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
