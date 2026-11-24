import 'package:flutter/material.dart';
import '../res/color_manager.dart';

/// Presentation widget rendering the Green Section Header Banner
/// matching the exact layout in the GSTSOF web portal screenshot:
/// Green rounded icon container + Title + Subtitle ("Manage your [entity], view details and take action.")
/// + Green primary action button (e.g. "+ Create Invoice", "+ Add Customer", "Choose Item")
class WebSectionBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final IconData? actionIcon;

  const WebSectionBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onActionPressed,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green Square Icon Box matching web screenshot
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ColorManager.primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Green Action Button
          ElevatedButton.icon(
            onPressed: onActionPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            icon: Icon(actionIcon ?? Icons.add_rounded, size: 16, color: Colors.white),
            label: Text(
              actionLabel,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }
}

