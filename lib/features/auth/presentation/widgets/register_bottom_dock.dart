import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';

/// Bottom Dock containing the Primary Action Button and Login Navigation
/// Styled in alignment with the app's official Forest Green theme:
/// - Gradient from ColorManager.primaryGreen to ColorManager.accentGreen
/// - Theme-colored glow shadow
/// - Clean forward icon and smooth loading state
class RegisterBottomDock extends StatelessWidget {
  final int currentStep; // 1, 2, or 3
  final bool isLoading;
  final VoidCallback onCtaPressed;
  final VoidCallback onSignInTap;

  const RegisterBottomDock({
    super.key,
    required this.currentStep,
    this.isLoading = false,
    required this.onCtaPressed,
    required this.onSignInTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight;

    String ctaText;
    if (isLoading) {
      ctaText = 'Creating…';
    } else if (currentStep == 1) {
      ctaText = 'Continue';
    } else if (currentStep == 2) {
      ctaText = 'Create account';
    } else {
      ctaText = 'Go to sign in';
    }

    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: 14.0 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary Theme Gradient Button
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [ColorManager.primaryGreen, ColorManager.accentGreen],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.38),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : onCtaPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ctaText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
          ),

          // Sign In Footer Link (Only shown on Steps 1 & 2)
          if (currentStep < 3) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onSignInTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: muted,
                      fontFamily: 'Inter',
                    ),
                    children: const [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: ColorManager.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
