import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/register_provider.dart';
import '../widgets/register_business_step.dart';
import '../widgets/register_personal_step.dart';

/// Modern Professional Multi-step Register Page using clean decoupled widgets, theme-colored shadows, GoRouter, and GlobalLoader.
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

  void _onRegister() async {
    if (_personalFormKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        context.showSnackBar(StringManager.passwordsDoNotMatch, isError: true);
        return;
      }
      GlobalLoader.show(context, message: 'Creating account...');
      final success = await ref.read(registerNotifierProvider.notifier).register(
            signupToken: 'token_dummy_123',
            panNo: 'ABCDE1234F',
            companyName: _companyController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            referralCode: _referralController.text,
          );
      if (!mounted) return;
      GlobalLoader.hide(context);

      if (success) {
        context.showSnackBar(StringManager.accountRegisteredSuccessfully);
        context.go(AppRouter.dashboard);
      } else {
        final err = ref.read(registerNotifierProvider).errorMessage ?? 'Registration failed';
        context.showSnackBar(err, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registerNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? ColorManager.white : ColorManager.lightTextPrimary,
          ),
          onPressed: regState.currentStep == 1 ? _onBack : () => context.go(AppRouter.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : Colors.grey.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.25 : 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
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
                      ? RegisterBusinessStep(
                          key: const ValueKey(0),
                          formKey: _businessFormKey,
                          gstinController: _gstinController,
                          companyController: _companyController,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          accountType: regState.accountType,
                          onAccountTypeChanged: (val) {
                            if (val != null) {
                              ref.read(registerNotifierProvider.notifier).setAccountType(val);
                            }
                          },
                          onContinue: _onContinue,
                          onSignInTap: () => context.go(AppRouter.login),
                          isDark: isDark,
                        )
                      : RegisterPersonalStep(
                          key: const ValueKey(1),
                          formKey: _personalFormKey,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          referralController: _referralController,
                          obscurePassword: regState.obscurePassword,
                          obscureConfirmPassword: regState.obscureConfirmPassword,
                          onTogglePassword: () => ref.read(registerNotifierProvider.notifier).toggleObscurePassword(),
                          onToggleConfirmPassword: () => ref.read(registerNotifierProvider.notifier).toggleObscureConfirmPassword(),
                          onBack: _onBack,
                          onRegister: _onRegister,
                          onSignInTap: () => context.go(AppRouter.login),
                          isLoading: regState.isLoading,
                          isDark: isDark,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
