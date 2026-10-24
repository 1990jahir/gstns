import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/styles_manager.dart';

class RegisterSuccessPane extends StatefulWidget {
  final String firstName;
  final String companyName;

  const RegisterSuccessPane({
    super.key,
    required this.firstName,
    required this.companyName,
  });

  @override
  State<RegisterSuccessPane> createState() => _RegisterSuccessPaneState();
}

class _RegisterSuccessPaneState extends State<RegisterSuccessPane>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.3, 1.5, 0.5, 1.0),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? ColorManager.authTextDark : ColorManager.authTextLight;
    final mutedColor = isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight;

    final displayFirstName = widget.firstName.trim().isNotEmpty ? widget.firstName.trim() : 'there';
    final displayCompany = widget.companyName.trim().isNotEmpty ? widget.companyName.trim() : 'your business';

    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated Tick Circle Badge (84x84) in Theme Green
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [ColorManager.primaryGreen, ColorManager.accentGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryGreen.withValues(alpha: 0.38),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            'You’re all set',
            style: getBoldStyle(
              fontSize: 22,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          // Personalized message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Welcome, $displayFirstName. Sign in to start managing $displayCompany.',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: 14,
                color: mutedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
