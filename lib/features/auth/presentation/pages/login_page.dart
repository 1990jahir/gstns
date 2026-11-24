import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_role_segmented_switch.dart';
import '../widgets/login_header.dart';
import '../../../../core/widgets/global_input_field.dart';
import '../widgets/login_social_button.dart';

/// Modern Professional Login Page with Dual-Tab (Client vs Partner) authentication,
/// theme-colored shadows, glowing logo aura, and real API authentication.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _clientFormKey = GlobalKey<FormState>();
  final _partnerFormKey = GlobalKey<FormState>();

  // Active Role Tab: 'client' or 'partner'
  String _activeRole = 'client';

  // Client Controllers
  final _clientEmailController = TextEditingController(text: 'sbuser1@gstsof.com');
  final _clientPasswordController = TextEditingController(text: 'Abc123@@');

  // Partner Controllers
  final _partnerIdentifierController = TextEditingController();
  final _partnerPasswordController = TextEditingController();

  @override
  void dispose() {
    _clientEmailController.dispose();
    _clientPasswordController.dispose();
    _partnerIdentifierController.dispose();
    _partnerPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignInClient() async {
    if (_clientFormKey.currentState?.validate() ?? false) {
      GlobalLoader.show(context, message: 'Signing in...');
      final success = await ref.read(authNotifierProvider.notifier).login(
            _clientEmailController.text.trim(),
            _clientPasswordController.text,
          );
      if (!mounted) return;
      GlobalLoader.hide(context);

      if (success) {
        context.showSnackBar('Successfully signed in as ${_clientEmailController.text}');
        context.go(AppRouter.dashboard);
      } else {
        final errorMsg = ref.read(authNotifierProvider).errorMessage ?? 'Login failed';
        context.showSnackBar(errorMsg, isError: true);
      }
    }
  }

  Future<void> _onSignInPartner() async {
    if (_partnerFormKey.currentState?.validate() ?? false) {
      GlobalLoader.show(context, message: 'Signing in to Partner Portal...');
      final success = await ref.read(authNotifierProvider.notifier).login(
            _partnerIdentifierController.text.trim(),
            _partnerPasswordController.text,
          );
      if (!mounted) return;
      GlobalLoader.hide(context);

      if (success) {
        context.showSnackBar('Partner authentication successful!');
        context.go(AppRouter.dashboard);
      } else {
        final errorMsg = ref.read(authNotifierProvider).errorMessage ?? 'Partner login failed';
        context.showSnackBar(errorMsg, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClient = _activeRole == 'client';

    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBackgroundApp : ColorManager.lightBackgroundApp,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.0, MediaQuery.paddingOf(context).top + 16.0, 24.0, 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Action (Theme Mode Toggle)
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(themeModeProvider.notifier).state = !isDarkMode;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? ColorManager.darkCardSurface : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.3 : 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          isDarkMode ? Icons.light_mode_rounded : Icons.nightlight_round,
                          size: 20,
                          color: isDarkMode ? Colors.amber : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Professional Card Container holding Login form with theme-colored shadow
                  Container(
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: isDark ? ColorManager.darkCardSurface : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark ? ColorManager.darkBorderColor : Colors.grey.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.25 : 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Login Header with dynamic title and subtitle
                        LoginHeader(
                          title: isClient ? StringManager.welcomeBack : StringManager.partnerLoginTitle,
                          subtitle: isClient
                              ? StringManager.clientPortalSubtitle
                              : StringManager.partnerPortalSubtitle,
                        ),
                        const SizedBox(height: 24),

                        // Dual-Tab Role Switch (Client vs Partner)
                        AuthRoleSegmentedSwitch(
                          selectedRole: _activeRole,
                          onRoleChanged: (newRole) {
                            setState(() {
                              _activeRole = newRole;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Dynamic Tab Content
                        if (isClient) _buildClientLoginForm(isDark, authState) else _buildPartnerLoginForm(isDark, authState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isClient ? StringManager.newToPlatform : StringManager.alreadyPartner,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(
                            AppRouter.register,
                            extra: isClient ? 'client' : 'partner',
                          );
                        },
                        child: Text(
                          isClient ? StringManager.createAnAccount : StringManager.joinPartnerNetwork,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Client Login Form (Business Accounts)
  Widget _buildClientLoginForm(bool isDark, dynamic authState) {
    return Form(
      key: _clientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlobalInputField(
            label: StringManager.emailLabel,
            hintText: StringManager.emailHint,
            prefixIcon: Icons.mail_outline_rounded,
            obscureText: false,
            controller: _clientEmailController,
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          GlobalInputField(
            label: StringManager.passwordLabel,
            hintText: StringManager.passwordHint,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: authState.obscurePassword,
            controller: _clientPasswordController,
            validator: Validators.validatePassword,
            suffixWidget: IconButton(
              icon: Icon(
                authState.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: () {
                ref.read(authNotifierProvider.notifier).toggleObscurePassword();
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      value: authState.rememberMe,
                      activeColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        ref.read(authNotifierProvider.notifier).toggleRememberMe(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    StringManager.rememberMe,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.showSnackBar(StringManager.forgotPasswordClicked),
                child: const Text(
                  StringManager.forgotPassword,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Sign In Button
          _buildActionButton(
            label: StringManager.signIn,
            isLoading: authState.isLoading,
            onPressed: _onSignInClient,
          ),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? ColorManager.darkBorderColor : const Color(0xFFE5E7EB),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  StringManager.orContinueWith,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? ColorManager.darkBorderColor : const Color(0xFFE5E7EB),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Social Buttons
          LoginSocialButton(
            assetPath: 'assets/png_images/google.png',
            text: StringManager.googleLogin,
            onTap: () => context.showSnackBar(StringManager.googleLoginClicked),
          ),
          const SizedBox(height: 12),
          LoginSocialButton(
            assetPath: 'assets/png_images/whatsapp.png',
            text: StringManager.whatsappLogin,
            onTap: () => context.showSnackBar(StringManager.whatsAppLoginClicked),
          ),
        ],
      ),
    );
  }

  /// Partner Login Form (CAs, Tax Advocates, Practitioners)
  Widget _buildPartnerLoginForm(bool isDark, dynamic authState) {
    return Form(
      key: _partnerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Professional Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.primaryGreen.withValues(alpha: 0.12)
                  : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: ColorManager.primaryGreen.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryGreen.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StringManager.partnerPortalBanner,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        StringManager.partnerPortalBannerSub,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          GlobalInputField(
            label: StringManager.partnerEmailOrMembership,
            hintText: StringManager.partnerEmailOrMembershipHint,
            prefixIcon: Icons.badge_outlined,
            obscureText: false,
            controller: _partnerIdentifierController,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return StringManager.membershipRequired;
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          GlobalInputField(
            label: StringManager.passwordLabel,
            hintText: StringManager.passwordHint,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: authState.obscurePassword,
            controller: _partnerPasswordController,
            validator: Validators.validatePassword,
            suffixWidget: IconButton(
              icon: Icon(
                authState.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: () {
                ref.read(authNotifierProvider.notifier).toggleObscurePassword();
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      value: authState.rememberMe,
                      activeColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        ref.read(authNotifierProvider.notifier).toggleRememberMe(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    StringManager.rememberMe,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.showSnackBar(StringManager.forgotPasswordClicked),
                child: const Text(
                  StringManager.forgotPassword,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Partner Sign In Button
          _buildActionButton(
            label: StringManager.partnerSignIn,
            isLoading: authState.isLoading,
            onPressed: _onSignInPartner,
          ),
        ],
      ),
    );
  }

  /// Reusable Primary Action Button
  Widget _buildActionButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.35),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
