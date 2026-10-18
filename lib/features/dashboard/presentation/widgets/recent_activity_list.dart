import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';

/// Recent Activity widget matching the screenshot.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = [
      {'title': 'SB USER4 loggedin on 18/10/2026 12:54 PM', 'date': '18 Oct 2026 • 12:54 PM • (Just now)'},
      {'title': 'SB USER4 loggedin on 13/10/2026 06:33 PM', 'date': '13 Oct 2026 • 06:33 PM • (5 days ago)'},
      {'title': 'SB USER4 loggedin on 13/10/2026 06:21 PM', 'date': '13 Oct 2026 • 06:21 PM • (5 days ago)'},
      {'title': 'SB USER4 loggedin on 13/10/2026 06:15 PM', 'date': '13 Oct 2026 • 06:15 PM • (5 days ago)'},
      {'title': 'SB USER4 loggedin on 12/10/2026 01:56 PM', 'date': '12 Oct 2026 • 01:56 PM • (6 days ago)'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: getBoldStyle(
                  fontSize: FontManager.s18,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All >',
                  style: getMediumStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...activities.map((act) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline_rounded, color: Colors.purple, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act['title']!,
                            style: getMediumStyle(
                              fontSize: FontManager.s14,
                              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            act['date']!,
                            style: getRegularStyle(
                              fontSize: FontManager.s12,
                              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'User',
                        style: getMediumStyle(fontSize: FontManager.s12, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
