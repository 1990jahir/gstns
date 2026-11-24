import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/gst_provider.dart';
import '../widgets/gstr1_section_card.dart';

/// Modern GSTR-1 Return Filing Preview Page refactored to Riverpod ConsumerWidget.
class Gstr1Page extends ConsumerWidget {
  const Gstr1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sections = ref.watch(gstr1SectionsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.gstr1Title,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export Portal JSON',
            onPressed: () => context.showSnackBar('Exporting GSTR-1 JSON...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Return Period Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.primaryGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.25)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Period: October 2026',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ColorManager.primaryGreen),
                      ),
                      Text(
                        'Due Date: 11 November 2026',
                        style: TextStyle(fontSize: 12, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                  Icon(Icons.verified_rounded, color: ColorManager.primaryGreen, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Cards from Provider
            ...sections.map((sec) => Gstr1SectionCard(section: sec)),
          ],
        ),
      ),
    );
  }
}
