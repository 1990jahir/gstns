import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/purchase_provider.dart';
import '../widgets/incoming_invoice_card.dart';

/// Modern Incoming Invoices (GSTR-2B Sync) Page connected to Riverpod.
class IncomingInvoicesPage extends ConsumerWidget {
  const IncomingInvoicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incomingInvoices = ref.watch(incomingInvoicesListProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.incomingInvoices,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            tooltip: 'Sync GSTR-2B from Portal',
            onPressed: () => context.showSnackBar('Syncing GSTR-2B from GST Portal...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: incomingInvoices.length,
          itemBuilder: (context, index) {
            return IncomingInvoiceCard(invoice: incomingInvoices[index]);
          },
        ),
      ),
    );
  }
}
