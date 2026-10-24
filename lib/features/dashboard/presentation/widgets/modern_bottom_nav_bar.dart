import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';

/// Client-Choice Modern Bottom Navigation Bar
/// Featuring:
/// - Curved top-left and top-right corners (24px radius)
/// - Theme-color (Forest Green) ambient glow shadow effect
/// - 0: Report (Icons.bar_chart_rounded)
/// - 1: Invoices (Icons.description_outlined)
/// - 2: Home (Center elevated circular button; theme-color when selected, unselected color when inactive)
/// - 3: Customer (Icons.people_outline_rounded)
/// - 4: More (Icons.grid_view_rounded, opens Menu sheet)
class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    final items = [
      {'icon': Icons.bar_chart_rounded, 'activeIcon': Icons.bar_chart_rounded, 'label': 'Report'},
      {'icon': Icons.description_outlined, 'activeIcon': Icons.description_rounded, 'label': 'Invoices'},
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home', 'isCenter': true},
      {'icon': Icons.people_outline_rounded, 'activeIcon': Icons.people_rounded, 'label': 'Customer'},
      {'icon': Icons.grid_view_rounded, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          // Theme-colored green shadow glow
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.3 : 0.16),
            blurRadius: 24,
            offset: const Offset(0, -6),
            spreadRadius: 2,
          ),
          // Soft ambient shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isCenter = item['isCenter'] == true;
              final isSelected = currentIndex == index;

              if (isCenter) {
                final unselectedBg = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
                final unselectedIconColor = isDark ? ColorManager.darkTextSecondary : const Color(0xFF64748B);

                return GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected ? ColorManager.primaryGreen : unselectedBg,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? ColorManager.darkSurface : Colors.white,
                              width: 3.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: ColorManager.primaryGreen.withValues(alpha: 0.45),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Icon(
                            isSelected ? Icons.home_rounded : Icons.home_outlined,
                            color: isSelected ? Colors.white : unselectedIconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: Text(
                          'Home',
                          style: isSelected
                              ? getBoldStyle(
                                  fontSize: FontManager.s11,
                                  color: ColorManager.primaryGreen,
                                )
                              : getRegularStyle(
                                  fontSize: FontManager.s11,
                                  color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final iconData = isSelected ? (item['activeIcon'] as IconData) : (item['icon'] as IconData);
              final label = item['label'] as String;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 24,
                        color: isSelected
                            ? ColorManager.primaryGreen
                            : (isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: isSelected
                            ? getBoldStyle(
                                fontSize: FontManager.s11,
                                color: ColorManager.primaryGreen,
                              )
                            : getRegularStyle(
                                fontSize: FontManager.s11,
                                color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
