import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/gst_provider.dart';
import '../widgets/reconcile_item_card.dart';
import '../widgets/reconcile_match_meter.dart';

/// Modern Smart GSTR-2B 3-Way Reconciliation Page refactored to Riverpod ConsumerWidget.
class Gstr2bReconcilePage extends ConsumerWidget {
  const Gstr2bReconcilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFilter = ref.watch(reconcileFilterProvider);
    final filteredItems = ref.watch(filteredGstr2bItemsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.gstr2bReconcileTitle,
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
            tooltip: 'Sync Live Portal Data',
            onPressed: () => context.showSnackBar('Re-syncing with GST Portal...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Match Meter Progress Card Widget
            const ReconcileMatchMeter(),
            const SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Matched', 'Mismatch', 'Missing in 2B'].map((f) {
                  final isSelected = selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) ref.read(reconcileFilterProvider.notifier).state = f;
                      },
                      selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.18),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      side: BorderSide(
                        color: isSelected
                            ? ColorManager.primaryGreen
                            : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Inward Reconciliation Items from Provider
            ...filteredItems.map((item) => ReconcileItemCard(item: item)),
          ],
        ),
      ),
    );
  }
}
