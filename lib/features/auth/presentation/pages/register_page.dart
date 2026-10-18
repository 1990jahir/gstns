import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_footer.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/register_provider.dart';
import '../widgets/step_indicator.dart';

/// Multi-step Register Page using clean, globally shared decoupled core widgets and GoRouter.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _businessFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();

  final _gstinController = TextEditingController(text: '19ABCDE1234F1Z5');
  final _companyController = TextEditingController(text: 'Test');
  final _firstNameController = TextEditingController(text: 'Test');
  final _lastNameController = TextEditingController(text: 'Ilb');

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  @override
  void dispose() {
    _gstinController.dispose();
    _companyController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_businessFormKey.currentState?.validate() ?? false) {
      ref.read(registerNotifierProvider.notifier).setStep(1);
    }
  }

  void _onBack() {
    ref.read(registerNotifierProvider.notifier).setStep(0);
  }

  void _onRegister() {
    if (_personalFormKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        context.showSnackBar(StringManager.passwordsDoNotMatch, isError: true);
        return;
      }
      ref.read(registerNotifierProvider.notifier).setLoading(true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          ref.read(registerNotifierProvider.notifier).setLoading(false);
          context.showSnackBar('Account registered successfully!');
          context.go(AppRouter.dashboard);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registerNotifierProvider);
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: regState.currentStep == 1
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? ColorManager.white : ColorManager.lightTextPrimary),
                onPressed: _onBack,
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? ColorManager.white : ColorManager.lightTextPrimary),
                onPressed: () => context.go(AppRouter.login),
              ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: regState.currentStep == 0
                    ? _buildBusinessInfoStep(isDark, regState)
                    : _buildPersonalInfoStep(isDark, regState),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessInfoStep(bool isDark, RegisterState regState) {
    return KeyedSubtree(
      key: const ValueKey(0),
      child: Form(
        key: _businessFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(
              title: StringManager.createYourAccount,
              subtitle: StringManager.registerSubtitle,
            ),
            const SizedBox(height: 28),
            const StepIndicator(currentStep: 0),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringManager.accountType,
                        style: getMediumStyle(
                          fontSize: FontManager.s14,
                          color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: regState.accountType,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Registered', 'Unregistered', 'Composition']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type, style: getRegularStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.white : ColorManager.black)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(registerNotifierProvider.notifier).setAccountType(val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: StringManager.gstin,
                    hintText: '19ABCDE...',
                    controller: _gstinController,
                    validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: StringManager.companyName,
              hintText: 'Company Name',
              controller: _companyController,
              validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: StringManager.firstName,
                    hintText: 'First Name',
                    controller: _firstNameController,
                    validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: StringManager.lastName,
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: StringManager.continueBtn,
              icon: Icons.arrow_forward_rounded,
              onPressed: _onContinue,
            ),
            const SizedBox(height: 28),
            CustomFooter(
              text: StringManager.alreadyHaveAccount,
              actionText: StringManager.signInLink,
              onTap: () => context.go(AppRouter.login),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep(bool isDark, RegisterState regState) {
    return KeyedSubtree(
      key: const ValueKey(1),
      child: Form(
        key: _personalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(
              title: StringManager.createYourAccount,
              subtitle: StringManager.registerSubtitle,
            ),
            const SizedBox(height: 28),
            const StepIndicator(currentStep: 1),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: StringManager.email,
                    hintText: 'name@example.com',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: StringManager.phoneNumber,
                    hintText: '9876543210',
                    controller: _phoneController,
                    validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
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
                    controller: _passwordController,
                    validator: Validators.validatePassword,
                    obscureText: regState.obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        regState.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: ColorManager.grey,
                      ),
                      onPressed: () => ref.read(registerNotifierProvider.notifier).toggleObscurePassword(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: StringManager.confirmPassword,
                    hintText: '••••••••',
                    controller: _confirmPasswordController,
                    validator: Validators.validatePassword,
                    obscureText: regState.obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        regState.obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: ColorManager.grey,
                      ),
                      onPressed: () => ref.read(registerNotifierProvider.notifier).toggleObscureConfirmPassword(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: StringManager.referralCode,
              hintText: 'Optional Code',
              controller: _referralController,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onBack,
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
                    isLoading: regState.isLoading,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _onRegister,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            CustomFooter(
              text: StringManager.alreadyHaveAccount,
              actionText: StringManager.signInLink,
              onTap: () => context.go(AppRouter.login),
            ),
          ],
        ),
      ),
    );
  }
}
