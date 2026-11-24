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
import '../widgets/debit_note_card.dart';

/// Modern Debit Notes Page matching the GSTSOF web portal design:
/// - Screen title: Debit Notes
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Debit Note No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Debit Notes", subtitle, action button: "+ Create Debit Note"
/// - Table list with exact web fields: SL. No, Action, Date, Debit Note No., Original Bill No., Vendor Name, Reason, Debit Amount, Status
class DebitNotesPage extends ConsumerWidget {
  const DebitNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notes = ref.watch(filteredDebitNotesProvider);
    final entriesPerPage = ref.watch(debitNoteEntriesPerPageProvider);
    final searchBy = ref.watch(debitNoteSearchByProvider);
    final searchQuery = ref.watch(debitNoteSearchQueryProvider);
    final startDate = ref.watch(debitNoteStartDateProvider);
    final endDate = ref.watch(debitNoteEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.debitNotes,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing debit notes...'),
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
                if (val != null) ref.read(debitNoteEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(debitNoteStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(debitNoteEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying debit note date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Debit Note No.', 'Vendor Name', 'Bill Ref'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(debitNoteSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(debitNoteSearchQueryProvider.notifier).state = val,
              searchHint: 'Search debit notes...',
            ),

            WebSectionBanner(
              icon: Icons.assignment_returned_rounded,
              title: StringManager.debitNotes,
              subtitle: StringManager.debitNotesSubtitle,
              actionLabel: StringManager.createDebitNote,
              onActionPressed: () => context.push(AppRouter.createDebitNote),
            ),

            Expanded(
              child: notes.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return DebitNoteCard(debitNote: notes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
