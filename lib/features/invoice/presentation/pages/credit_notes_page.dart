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
import '../widgets/credit_note_card.dart';

/// Modern Credit Notes Page matching the GSTSOF web portal design:
/// - Screen title: Credit Notes
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Credit Note No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Credit Notes", subtitle, action button: "+ Create Credit Note"
/// - Table list with exact web fields: SL. No, Action, Date, Credit Note No., Original Invoice No., Customer Name, Reason, Credit Amount, Status
class CreditNotesPage extends ConsumerWidget {
  const CreditNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notes = ref.watch(filteredCreditNotesProvider);
    final entriesPerPage = ref.watch(creditNoteEntriesPerPageProvider);
    final searchBy = ref.watch(creditNoteSearchByProvider);
    final searchQuery = ref.watch(creditNoteSearchQueryProvider);
    final startDate = ref.watch(creditNoteStartDateProvider);
    final endDate = ref.watch(creditNoteEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.creditNotes,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing credit notes...'),
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
                if (val != null) ref.read(creditNoteEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(creditNoteStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(creditNoteEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying credit note date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Credit Note No.', 'Customer Name', 'Invoice No.'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(creditNoteSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(creditNoteSearchQueryProvider.notifier).state = val,
              searchHint: 'Search credit notes...',
            ),

            WebSectionBanner(
              icon: Icons.assignment_return_rounded,
              title: StringManager.creditNotes,
              subtitle: StringManager.creditNotesSubtitle,
              actionLabel: StringManager.createCreditNote,
              onActionPressed: () => context.push(AppRouter.createCreditNote),
            ),

            Expanded(
              child: notes.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return CreditNoteCard(creditNote: notes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
