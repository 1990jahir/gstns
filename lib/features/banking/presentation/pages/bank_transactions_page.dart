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
import '../providers/banking_provider.dart';
import '../widgets/bank_transaction_tile.dart';

/// Modern Bank Transactions Stream Page matching the GSTSOF web portal design:
/// - Screen title: Bank Transactions
/// - Top right: Refresh button (Blue pill with sync icon)
/// - Filter Toolbar: Show [50], Start Date, End Date, [ Q green button ], Search By [ Ref / No. v ], Search [ input Q ]
/// - Section Banner: Green box icon, "Bank Transactions", subtitle, action button: "+ Record Payment"
/// - Table list with exact web fields: SL. No, Action, Date, Account Name, Type, Ref / Cheque No., Party, Debit (Dr), Credit (Cr), Balance, Status
class BankTransactionsPage extends ConsumerWidget {
  const BankTransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactions = ref.watch(filteredTransactionsProvider);
    final entriesPerPage = ref.watch(transactionEntriesPerPageProvider);
    final searchBy = ref.watch(transactionSearchByProvider);
    final searchQuery = ref.watch(transactionSearchQueryProvider);
    final startDate = ref.watch(transactionStartDateProvider);
    final endDate = ref.watch(transactionEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.bankTransactions,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing bank passbook...'),
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
                if (val != null) ref.read(transactionEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(transactionStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(transactionEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying transaction date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Ref / No.', 'Account', 'Party'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(transactionSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(transactionSearchQueryProvider.notifier).state = val,
              searchHint: 'Search bank transactions...',
            ),

            WebSectionBanner(
              icon: Icons.account_balance_wallet_rounded,
              title: StringManager.bankTransactions,
              subtitle: StringManager.bankTransactionsSubtitle,
              actionLabel: StringManager.recordPayment,
              onActionPressed: () => context.push(AppRouter.recordPayment),
            ),

            Expanded(
              child: transactions.isEmpty
                  ? const WebEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return BankTransactionTile(transaction: transactions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
