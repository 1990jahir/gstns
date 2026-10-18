import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_footer.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';

/// Login Page using clean, globally shared decoupled core widgets.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'suser4@gstsof.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).setLoading(true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          ref.read(authNotifierProvider.notifier).setLoading(false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? ColorManager.white : ColorManager.lightTextPrimary,
              ),
              onPressed: () {
                ref.read(themeModeProvider.notifier).state = !isDarkMode;
              },
              tooltip: 'Toggle Theme',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Global Reusable Header
                    const CustomHeader(
                      title: StringManager.welcomeBack,
                      subtitle: StringManager.signInSubtitle,
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    CustomTextField(
                      label: StringManager.emailLabel,
                      hintText: StringManager.emailHint,
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: ColorManager.primaryGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    CustomTextField(
                      label: StringManager.passwordLabel,
                      hintText: StringManager.passwordHint,
                      controller: _passwordController,
                      validator: Validators.validatePassword,
                      obscureText: authState.obscurePassword,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: ColorManager.primaryGreen,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authState.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ColorManager.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).toggleObscurePassword();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: authState.rememberMe,
                                  onChanged: (value) {
                                    ref.read(authNotifierProvider.notifier).toggleRememberMe(value);
                                  },
                                  activeColor: ColorManager.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  StringManager.rememberMe,
                                  overflow: TextOverflow.ellipsis,
                                  style: getMediumStyle(
                                    fontSize: FontManager.s14,
                                    color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            context.showSnackBar('Forgot password clicked');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            StringManager.forgotPassword,
                            style: getMediumStyle(
                              fontSize: FontManager.s14,
                              color: ColorManager.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign In Button
                    CustomButton(
                      text: StringManager.signIn,
                      isLoading: authState.isLoading,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _onSignIn,
                    ),
                    const SizedBox(height: 28),

                    // Divider "or continue with"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            StringManager.orContinueWith,
                            style: getRegularStyle(
                              fontSize: FontManager.s13,
                              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Logins (Google & WhatsApp)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            context.showSnackBar('Google login clicked');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            side: BorderSide(
                              color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: isDark ? ColorManager.darkCard : ColorManager.lightCard,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.g_mobiledata_rounded,
                                size: 28,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  StringManager.googleLogin,
                                  style: getMediumStyle(
                                    fontSize: FontManager.s14,
                                    color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            context.showSnackBar('WhatsApp login clicked');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            side: BorderSide(
                              color: isDark ? ColorManager.darkBorder : ColorManager.lightBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: isDark ? ColorManager.darkCard : ColorManager.lightCard,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 20,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  StringManager.whatsappLogin,
                                  style: getMediumStyle(
                                    fontSize: FontManager.s14,
                                    color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Global Reusable Footer
                    CustomFooter(
                      text: StringManager.newToPlatform,
                      actionText: StringManager.createAnAccount,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
