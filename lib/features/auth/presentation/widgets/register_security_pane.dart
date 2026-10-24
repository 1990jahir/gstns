import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/widgets/global_input_field.dart';
import 'floating_label_input.dart';
import 'password_strength_meter.dart';

class RegisterSecurityPane extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController referralController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final String? emailErrorMessage;
  final String? phoneErrorMessage;
  final String? passwordErrorMessage;
  final String? confirmPasswordMessage;
  final bool isConfirmPasswordOk;

  const RegisterSecurityPane({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.referralController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    this.emailErrorMessage,
    this.phoneErrorMessage,
    this.passwordErrorMessage,
    this.confirmPasswordMessage,
    this.isConfirmPasswordOk = false,
  });

  @override
  State<RegisterSecurityPane> createState() => _RegisterSecurityPaneState();
}

class _RegisterSecurityPaneState extends State<RegisterSecurityPane> {
  bool _showReferralField = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = isDark ? ColorManager.accentGreen : ColorManager.primaryGreen;
    final mutedColor = isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Input
        FloatingLabelInput(
          controller: widget.emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          validationState: widget.emailErrorMessage != null
              ? InputValidationState.error
              : (widget.emailController.text.isNotEmpty
                  ? InputValidationState.valid
                  : InputValidationState.none),
          messageText: widget.emailErrorMessage,
        ),
        const SizedBox(height: 10),

        // Phone Number Input with +91 prefix & 10-digit limiter
        FloatingLabelInput(
          controller: widget.phoneController,
          label: 'Phone number',
          prefixText: '+91',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validationState: widget.phoneErrorMessage != null
              ? InputValidationState.error
              : (widget.phoneController.text.length == 10
                  ? InputValidationState.valid
                  : InputValidationState.none),
          messageText: widget.phoneErrorMessage,
        ),
        const SizedBox(height: 10),

        // Password & Confirm Password (2 Column Row)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Password Field
            Expanded(
              child: FloatingLabelInput(
                controller: widget.passwordController,
                label: 'Password',
                obscureText: widget.obscurePassword,
                suffixWidth: 32.0,
                bottomWidget: PasswordStrengthMeter(
                  password: widget.passwordController.text,
                ),
                suffixWidget: IconButton(
                  icon: Icon(
                    widget.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 19,
                    color: !widget.obscurePassword ? brandColor : mutedColor,
                  ),
                  onPressed: widget.onTogglePassword,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                ),
                validationState: widget.passwordErrorMessage != null
                    ? InputValidationState.error
                    : (widget.passwordController.text.length >= 6
                        ? InputValidationState.valid
                        : InputValidationState.none),
              ),
            ),
            const SizedBox(width: 10),

            // Confirm Password Field
            Expanded(
              child: FloatingLabelInput(
                controller: widget.confirmPasswordController,
                label: 'Confirm',
                obscureText: widget.obscureConfirmPassword,
                suffixWidth: 32.0,
                suffixWidget: IconButton(
                  icon: Icon(
                    widget.obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 19,
                    color: !widget.obscureConfirmPassword ? brandColor : mutedColor,
                  ),
                  onPressed: widget.onToggleConfirmPassword,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                ),
                validationState: widget.confirmPasswordMessage != null
                    ? (widget.isConfirmPasswordOk
                        ? InputValidationState.valid
                        : InputValidationState.error)
                    : InputValidationState.none,
              ),
            ),
          ],
        ),

        // Live Password / Confirm Message Feedback
        if (widget.confirmPasswordMessage != null && widget.confirmPasswordMessage!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              widget.confirmPasswordMessage!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.isConfirmPasswordOk ? brandColor : ColorManager.authError,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ] else if (widget.passwordErrorMessage != null && widget.passwordErrorMessage!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              widget.passwordErrorMessage!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorManager.authError,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),

        // Referral Code Toggle Accordion
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              setState(() {
                _showReferralField = !_showReferralField;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              child: Text(
                _showReferralField ? '− Hide referral code' : '+ Have a referral code?',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: brandColor,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ),

        // Expandable Referral Code Field
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showReferralField
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FloatingLabelInput(
                    controller: widget.referralController,
                    label: 'Referral code (optional)',
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
