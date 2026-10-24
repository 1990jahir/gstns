import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Client-Choice Recent Activity List matching the reference screenshot.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: getBoldStyle(
                fontSize: FontManager.s18,
                color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
              ),
            ),
            InkWell(
              onTap: () => context.showSnackBar('Viewing all recent activity'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: getBoldStyle(
                      fontSize: FontManager.s13,
                      color: ColorManager.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: ColorManager.primaryGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // TODAY Group
        _buildDateHeader('TODAY', isDark),
        const SizedBox(height: 10),
        _buildActivityItem(
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF15803D),
          iconBgColor: const Color(0xFFDCFCE7),
          title: 'Invoice INV/26-27/1142 created for Gupta & Sons',
          badgeText: 'Invoice',
          badgeTextColor: const Color(0xFF15803D),
          badgeBgColor: const Color(0xFFDCFCE7),
          time: '11:42 AM',
          relativeTime: '12 min ago',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildActivityItem(
          icon: Icons.payments_outlined,
          iconColor: const Color(0xFF0F766E),
          iconBgColor: const Color(0xFFCCFBF1),
          title: 'Payment of ₹ 1,25,000 received from Mehta Traders',
          badgeText: 'Payment',
          badgeTextColor: const Color(0xFF0F766E),
          badgeBgColor: const Color(0xFFCCFBF1),
          time: '10:15 AM',
          relativeTime: '1 hr ago',
          isDark: isDark,
        ),
        const SizedBox(height: 20),

        // YESTERDAY Group
        _buildDateHeader('YESTERDAY', isDark),
        const SizedBox(height: 10),
        _buildActivityItem(
          icon: Icons.local_shipping_outlined,
          iconColor: const Color(0xFF0369A1),
          iconBgColor: const Color(0xFFE0F2FE),
          title: 'E-way bill 3410 9876 5521 generated',
          badgeText: 'E-Way Bill',
          badgeTextColor: const Color(0xFF0369A1),
          badgeBgColor: const Color(0xFFE0F2FE),
          time: '06:30 PM',
          relativeTime: '17 hrs ago',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildActivityItem(
          icon: Icons.receipt_long_outlined,
          iconColor: const Color(0xFFC2410C),
          iconBgColor: const Color(0xFFFFEDD5),
          title: 'Purchase bill PB/0806 added from Shree Steel Co.',
          badgeText: 'Purchase',
          badgeTextColor: const Color(0xFFC2410C),
          badgeBgColor: const Color(0xFFFFEDD5),
          time: '04:05 PM',
          relativeTime: '19 hrs ago',
          isDark: isDark,
        ),
        const SizedBox(height: 20),

        // 22 OCT 2026 Group
        _buildDateHeader('22 OCT 2026', isDark),
        const SizedBox(height: 10),
        _buildActivityItem(
          icon: Icons.currency_rupee_rounded,
          iconColor: const Color(0xFFBE185D),
          iconBgColor: const Color(0xFFFCE7F3),
          title: 'Expense added: Office rent ₹ 35,000',
          badgeText: 'Expense',
          badgeTextColor: const Color(0xFFBE185D),
          badgeBgColor: const Color(0xFFFCE7F3),
          time: '09:20 AM',
          relativeTime: '2 days ago',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildDateHeader(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String badgeText,
    required Color badgeTextColor,
    required Color badgeBgColor,
    required String time,
    required String relativeTime,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? ColorManager.darkBorder : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Box
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.2) : iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontSize: FontManager.s13,
                    color: isDark ? ColorManager.darkTextPrimary : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? badgeTextColor.withValues(alpha: 0.2) : badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: getRegularStyle(
                        fontSize: FontManager.s11,
                        color: isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      relativeTime,
                      style: getBoldStyle(
                        fontSize: FontManager.s11,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
