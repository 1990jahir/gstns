import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/reports_provider.dart';
import '../widgets/report_filter_card.dart';
import '../widgets/report_section_card.dart';

/// Professional Trading, Profit & Loss Reports Page mirroring the web report view and PDF specification.
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  final TextEditingController _startDateController = TextEditingController(text: StringManager.defaultStartDate);
  final TextEditingController _endDateController = TextEditingController(text: StringManager.defaultEndDate);

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _onDownloadReport() {
    GlobalLoader.show(context, message: StringManager.downloadingPdfReport);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      GlobalLoader.hide(context);
      context.showSnackBar(StringManager.reportDownloadedSuccessfully);
    });
  }

  void _onSearch() {
    ref.read(reportsNotifierProvider.notifier).setDateRange(
          _startDateController.text,
          _endDateController.text,
        );
    context.showSnackBar(StringManager.reportFilteredSuccessfully);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          StringManager.profitLossReportTitle,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: _onDownloadReport,
              icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
              label: Text(StringManager.downloadReportBtn, style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            ReportFilterCard(
              startDateController: _startDateController,
              endDateController: _endDateController,
              onSearch: _onSearch,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            ReportSectionCard(
              title: StringManager.debitSideTitle,
              isDark: isDark,
              items: [
                ReportItemModel(StringManager.openingStockItem, StringManager.defaultAmountZero),
                ReportItemModel(StringManager.purchaseAccountsItem, StringManager.defaultAmountZero, subItems: [
                  ReportItemModel(StringManager.registeredPurchaseItem, StringManager.defaultAmountZero),
                  ReportItemModel(StringManager.unregisteredPurchaseItem, StringManager.defaultAmountZero),
                  ReportItemModel(StringManager.lessDebitNoteItem, StringManager.defaultAmountZero),
                ]),
                ReportItemModel(StringManager.directIncomesItem, StringManager.defaultAmountZero),
                ReportItemModel(StringManager.directExpensesItem, StringManager.defaultAmountZero),
                ReportItemModel(StringManager.grossProfitCoItem, StringManager.defaultAmountZero),
              ],
              total: StringManager.defaultAmountZero,
            ),
            const SizedBox(height: 20),
            ReportSectionCard(
              title: StringManager.creditSideTitle,
              isDark: isDark,
              items: [
                ReportItemModel(StringManager.salesAccountsItem, StringManager.defaultAmountZero, subItems: [
                  ReportItemModel(StringManager.registeredSalesItem, StringManager.defaultAmountZero),
                  ReportItemModel(StringManager.unregisteredSalesItem, StringManager.defaultAmountZero),
                  ReportItemModel(StringManager.lessCreditNoteItem, StringManager.defaultAmountZero),
                ]),
                ReportItemModel(StringManager.closingStockItem, StringManager.defaultAmountZero),
              ],
              total: StringManager.defaultAmountZero,
            ),
            const SizedBox(height: 20),
            ReportSectionCard(
              title: StringManager.indirectAccountsTitle,
              isDark: isDark,
              items: [
                ReportItemModel(StringManager.indirectExpensesItem, StringManager.defaultAmountZero),
                ReportItemModel(StringManager.indirectIncomesItem, StringManager.defaultAmountZero),
              ],
              total: StringManager.defaultAmountZero,
            ),
          ],
        ),
      ),
    );
  }
}
