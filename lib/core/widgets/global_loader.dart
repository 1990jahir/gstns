import 'package:flutter/material.dart';
import '../res/color_manager.dart';
import '../res/font_manager.dart';
import '../res/styles_manager.dart';
import '../utils/extensions.dart';

/// Global Animated API Loader widget using logo_icon.png with theme support and pulse animation.
class GlobalLoader extends StatefulWidget {
  final String? message;

  const GlobalLoader({super.key, this.message});

  /// Displays the global loading overlay.
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => GlobalLoader(message: message),
    );
  }

  /// Hides the global loading overlay.
  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  State<GlobalLoader> createState() => _GlobalLoaderState();
}

class _GlobalLoaderState extends State<GlobalLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? ColorManager.darkCard : ColorManager.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ColorManager.primaryGreen.withValues(alpha: 0.2),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Logo Icon
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/png_images/logo_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Message
              Text(
                widget.message ?? 'Loading...',
                style: getMediumStyle(
                  fontSize: FontManager.s14,
                  color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // Progress Indicator
              const SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  color: ColorManager.primaryGreen,
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
