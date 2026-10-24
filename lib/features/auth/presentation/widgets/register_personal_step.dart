import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_footer.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/step_indicator.dart';
import 'register_header.dart';

/// Decoupled Personal Credentials Step (Step 1) for Register Page.
class RegisterPersonalStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController referralController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onBack;
  final VoidCallback onRegister;
  final VoidCallback onSignInTap;
  final bool isLoading;
  final bool isDark;

  const RegisterPersonalStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.referralController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onBack,
    required this.onRegister,
    required this.onSignInTap,
    required this.isLoading,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegisterHeader(),
          const SizedBox(height: 24),
          const StepIndicator(currentStep: 1),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.email,
                  hintText: 'name@example.com',
                  controller: emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.phoneNumber,
                  hintText: '9876543210',
                  controller: phoneController,
                  validator: (v) => v == null || v.length < 10 ? StringManager.enterValidPhone : null,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.passwordLabel,
                  hintText: '••••••••',
                  controller: passwordController,
                  validator: Validators.validatePassword,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: ColorManager.grey,
                    ),
                    onPressed: onTogglePassword,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.confirmPassword,
                  hintText: '••••••••',
                  controller: confirmPasswordController,
                  validator: Validators.validatePassword,
                  obscureText: obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: ColorManager.grey,
                    ),
                    onPressed: onToggleConfirmPassword,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: StringManager.referralCode,
            hintText: 'Optional Code',
            controller: referralController,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_rounded, size: 20, color: ColorManager.primaryGreen),
                      const SizedBox(width: 8),
                      Text(
                        StringManager.backBtn,
                        style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: StringManager.registerBtn,
                  isLoading: isLoading,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onRegister,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomFooter(
            text: StringManager.alreadyHaveAccount,
            actionText: StringManager.signInLink,
            onTap: onSignInTap,
          ),
        ],
      ),
    );
  }
}
