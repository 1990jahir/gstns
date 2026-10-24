import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Modern Report Section Card widget for displaying Profit & Loss particulars (Debit/Credit).
class ReportSectionCard extends StatelessWidget {
  final String title;
  final List<ReportItemModel> items;
  final String total;
  final bool isDark;

  const ReportSectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontSize: FontManager.s16,
              color: ColorManager.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...items.map((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: getBoldStyle(
                          fontSize: FontManager.s14,
                          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '₹ ${item.amount}',
                        style: getBoldStyle(
                          fontSize: FontManager.s14,
                          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (item.subItems != null) ...[
                    const SizedBox(height: 8),
                    ...item.subItems!.map((sub) => Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '- ${sub.name}',
                                style: getRegularStyle(
                                  fontSize: FontManager.s13,
                                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                                ),
                              ),
                              Text(
                                '₹ ${sub.amount}',
                                style: getMediumStyle(
                                  fontSize: FontManager.s13,
                                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 10),
                ],
              )),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: getBoldStyle(fontSize: FontManager.s15, color: ColorManager.primaryGreen),
              ),
              Text(
                '₹ $total',
                style: getBoldStyle(fontSize: FontManager.s15, color: ColorManager.primaryGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportItemModel {
  final String name;
  final String amount;
  final List<ReportItemModel>? subItems;

  ReportItemModel(this.name, this.amount, {this.subItems});
}
