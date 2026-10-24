import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
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
    required this.emailErrorMessage,
    required this.phoneErrorMessage,
    required this.passwordErrorMessage,
    required this.confirmPasswordMessage,
    required this.isConfirmPasswordOk,
  });

  @override
  State<RegisterSecurityPane> createState() => _RegisterSecurityPaneState();
}

class _RegisterSecurityPaneState extends State<RegisterSecurityPane> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Input
        FloatingLabelInput(
          controller: widget.emailController,
          label: 'Work Email Address',
          keyboardType: TextInputType.emailAddress,
          validationState: widget.emailErrorMessage != null ? InputValidationState.error : InputValidationState.none,
          messageText: widget.emailErrorMessage,
        ),
        const SizedBox(height: 16),

        // Mobile Number Input
        FloatingLabelInput(
          controller: widget.phoneController,
          label: 'Mobile Number',
          prefixText: '+91 ',
          keyboardType: TextInputType.phone,
          validationState: widget.phoneErrorMessage != null ? InputValidationState.error : InputValidationState.none,
          messageText: widget.phoneErrorMessage,
        ),
        const SizedBox(height: 16),

        // Password Input with strength meter & eye toggle
        FloatingLabelInput(
          controller: widget.passwordController,
          label: 'Create Password',
          obscureText: widget.obscurePassword,
          validationState: widget.passwordErrorMessage != null ? InputValidationState.error : InputValidationState.none,
          messageText: widget.passwordErrorMessage,
          suffixWidget: IconButton(
            icon: Icon(
              widget.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: ColorManager.grey,
            ),
            onPressed: widget.onTogglePassword,
          ),
          bottomWidget: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: PasswordStrengthMeter(password: widget.passwordController.text),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password Input
        FloatingLabelInput(
          controller: widget.confirmPasswordController,
          label: 'Confirm Password',
          obscureText: widget.obscureConfirmPassword,
          validationState: widget.confirmPasswordMessage != null
              ? (widget.isConfirmPasswordOk ? InputValidationState.valid : InputValidationState.error)
              : InputValidationState.none,
          messageText: widget.confirmPasswordMessage,
          isMessageOk: widget.isConfirmPasswordOk,
          suffixWidget: IconButton(
            icon: Icon(
              widget.obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: ColorManager.grey,
            ),
            onPressed: widget.onToggleConfirmPassword,
          ),
        ),
        const SizedBox(height: 16),

        // Referral Code (Optional)
        FloatingLabelInput(
          controller: widget.referralController,
          label: 'Referral Code (Optional)',
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
