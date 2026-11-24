import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../providers/banking_provider.dart';
import '../widgets/income_card.dart';

/// Modern Indirect & Other Income Ledger Page connected to Riverpod.
class IncomePage extends ConsumerWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incomes = ref.watch(incomeListProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.income,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.addIncome),
        backgroundColor: ColorManager.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          StringManager.addIncome,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Inter'),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            return IncomeCard(income: incomes[index]);
          },
        ),
      ),
    );
  }
}
