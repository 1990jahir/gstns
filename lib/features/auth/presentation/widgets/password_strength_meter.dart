import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
  });

  static int calculateStrength(String p) {
    if (p.isEmpty) return 0;
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]')) && p.contains(RegExp(r'[a-z]'))) s++;
    if (p.contains(RegExp(r'\d'))) s++;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  static Color getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return ColorManager.authError;
      case 2:
        return ColorManager.authSun;
      case 3:
        return const Color(0xFFE3B500);
      case 4:
        return ColorManager.authBrand;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = isDark ? ColorManager.authLineDark : ColorManager.authLineLight;
    final strength = calculateStrength(password);
    final activeColor = getStrengthColor(strength);

    return SizedBox(
      height: 3,
      child: Row(
        children: List.generate(4, (index) {
          final isSegmentActive = index < strength;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 3.0 : 0.0),
              decoration: BoxDecoration(
                color: isSegmentActive ? activeColor : lineColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }
}
