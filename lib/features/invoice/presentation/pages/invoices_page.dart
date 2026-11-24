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
import '../widgets/invoice_card.dart';

/// Modern Sales Invoices Page matching the GSTSOF web portal design:
/// - Screen title: Manage Invoices
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Invoice No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Tax Invoices", subtitle, action button: "+ Create Invoice"
/// - Table list with exact web fields: SL. No, Action, Date, Invoice No., Customer Name, GSTIN, Taxable Amount, Total Tax, Invoice Amount, Status, Due Date
class InvoicesPage extends ConsumerWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final invoices = ref.watch(filteredInvoicesProvider);
    final entriesPerPage = ref.watch(invoiceEntriesPerPageProvider);
    final searchBy = ref.watch(invoiceSearchByProvider);
    final searchQuery = ref.watch(invoiceSearchQueryProvider);
    final startDate = ref.watch(invoiceStartDateProvider);
    final endDate = ref.watch(invoiceEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.manageInvoices,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing invoices from server...'),
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
                if (val != null) ref.read(invoiceEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(invoiceStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(invoiceEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying invoice date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Invoice No.', 'Customer Name', 'GSTIN'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(invoiceSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(invoiceSearchQueryProvider.notifier).state = val,
              searchHint: 'Search invoices...',
            ),

            // Green Box Section Header Banner
            WebSectionBanner(
              icon: Icons.receipt_long_rounded,
              title: 'Tax Invoices',
              subtitle: StringManager.invoicesSubtitle,
              actionLabel: StringManager.createInvoice,
              onActionPressed: () => context.push(AppRouter.createInvoice),
            ),

            // Invoices List or Empty State
            Expanded(
              child: invoices.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        return InvoiceCard(invoice: invoices[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
