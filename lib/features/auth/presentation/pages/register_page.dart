import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/register_provider.dart';
import '../widgets/business_id_card_preview.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/register_bottom_dock.dart';
import '../widgets/register_business_pane.dart';
import '../widgets/register_header_new.dart';
import '../widgets/register_security_pane.dart';
import '../widgets/register_success_pane.dart';
import '../widgets/register_top_bar.dart';

/// Modern Revamped Multi-step Register Page
/// Based on the latest professional HTML design reference:
/// - Real-time Digital Business ID / GST Card preview with interactive shimmer
/// - Clean modular widgets and Plus Jakarta Sans / Sora / Inter typography
/// - Segmented control, GSTIN verification chip, 4-bar password strength meter, match validator
/// - Smooth step transitions and sticky dock with orange 'Go' action button
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // Step tracker: 1 = Business, 2 = Security, 3 = Success
  int _step = 1;

  // Controllers
  final _gstinController = TextEditingController();
  final _companyController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  // Step 1 Validation & Card State
  String _accountType = 'Registered';
  bool _isGstinVerified = false;
  bool _isVerifyingGstin = false;
  bool _triggerShine = false;
  String? _gstinErrorMessage;
  bool _isGstinMessageOk = false;
  String? _companyErrorMessage;
  String? _firstNameErrorMessage;
  String? _lastNameErrorMessage;

  // Step 2 Validation & State
  String? _emailErrorMessage;
  String? _phoneErrorMessage;
  String? _passwordErrorMessage;
  String? _confirmPasswordMessage;
  bool _isConfirmPasswordOk = false;

  static final RegExp _gstRegex = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$');
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRegex = RegExp(r'^[6-9]\d{9}$');

  @override
  void initState() {
    super.initState();
    _gstinController.addListener(_onGstinChanged);
    _companyController.addListener(_onFieldChanged);
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _gstinController.removeListener(_onGstinChanged);
    _companyController.removeListener(_onFieldChanged);
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);

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

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  void _onGstinChanged() {
    final v = _gstinController.text.trim().toUpperCase();
    if (_isGstinVerified) {
      setState(() {
        _isGstinVerified = false;
        _gstinErrorMessage = null;
        _isGstinMessageOk = false;
      });
    }

    if (v.isEmpty) {
      if (_gstinErrorMessage != null) {
        setState(() => _gstinErrorMessage = null);
      }
      return;
    }

    final isOk = _gstRegex.hasMatch(v);
    if (v.length == 15 && !isOk) {
      setState(() {
        _gstinErrorMessage = 'This GSTIN isn’t valid. Check the characters and try again.';
        _isGstinMessageOk = false;
      });
    } else if (v.length < 15) {
      setState(() {
        _gstinErrorMessage = '${v.length} of 15 characters';
        _isGstinMessageOk = false;
      });
    } else {
      if (_gstinErrorMessage != null) {
        setState(() => _gstinErrorMessage = null);
      }
    }
  }

  void _onPasswordChanged() {
    _onConfirmPasswordChanged();
  }

  void _onConfirmPasswordChanged() {
    final p1 = _passwordController.text;
    final p2 = _confirmPasswordController.text;

    if (p2.isEmpty) {
      if (_confirmPasswordMessage != null) {
        setState(() {
          _confirmPasswordMessage = null;
          _isConfirmPasswordOk = false;
        });
      }
      return;
    }

    if (p1 == p2) {
      setState(() {
        _confirmPasswordMessage = 'Passwords match';
        _isConfirmPasswordOk = true;
      });
    } else {
      setState(() {
        _confirmPasswordMessage = 'Passwords don’t match yet';
        _isConfirmPasswordOk = false;
      });
    }
  }

  void _handleVerifyGstin() {
    final gstin = _gstinController.text.trim().toUpperCase();
    if (!_gstRegex.hasMatch(gstin)) return;

    setState(() {
      _isVerifyingGstin = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isVerifyingGstin = false;
        _isGstinVerified = true;
        _gstinErrorMessage = 'Business details filled in';
        _isGstinMessageOk = true;
        _triggerShine = true;
        if (_companyController.text.trim().isEmpty) {
          _companyController.text = 'Sample Traders Pvt Ltd';
          _companyErrorMessage = null;
        }
      });

      // Reset shine trigger for future re-triggers
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _triggerShine = false);
      });
    });
  }

  void _handleStep1Continue() {
    bool hasError = false;

    if (_accountType == 'Registered') {
      final gstin = _gstinController.text.trim().toUpperCase();
      if (!_gstRegex.hasMatch(gstin)) {
        setState(() {
          _gstinErrorMessage = 'Enter your 15-character GSTIN, or choose Unregistered';
          _isGstinMessageOk = false;
        });
        hasError = true;
      }
    }

    if (_companyController.text.trim().isEmpty) {
      setState(() => _companyErrorMessage = 'Enter company name');
      hasError = true;
    } else {
      setState(() => _companyErrorMessage = null);
    }

    if (_firstNameController.text.trim().isEmpty) {
      setState(() => _firstNameErrorMessage = 'Enter first name');
      hasError = true;
    } else {
      setState(() => _firstNameErrorMessage = null);
    }

    if (_lastNameController.text.trim().isEmpty) {
      setState(() => _lastNameErrorMessage = 'Enter last name');
      hasError = true;
    } else {
      setState(() => _lastNameErrorMessage = null);
    }

    if (!hasError) {
      setState(() {
        _step = 2;
      });
      ref.read(registerNotifierProvider.notifier).setStep(1);
    }
  }

  void _handleStep2Register() async {
    bool hasError = false;

    final email = _emailController.text.trim();
    if (!_emailRegex.hasMatch(email)) {
      setState(() => _emailErrorMessage = 'Enter a valid email like you@company.com');
      hasError = true;
    } else {
      setState(() => _emailErrorMessage = null);
    }

    final phone = _phoneController.text.trim();
    if (!_phoneRegex.hasMatch(phone)) {
      setState(() => _phoneErrorMessage = 'Enter a 10-digit mobile number');
      hasError = true;
    } else {
      setState(() => _phoneErrorMessage = null);
    }

    final pw = _passwordController.text;
    final strength = PasswordStrengthMeter.calculateStrength(pw);
    if (strength < 2) {
      setState(() => _passwordErrorMessage = 'Password is too weak. Use 8+ characters with a number or symbol.');
      hasError = true;
    } else {
      setState(() => _passwordErrorMessage = null);
    }

    final pw2 = _confirmPasswordController.text;
    if (pw != pw2) {
      setState(() {
        _confirmPasswordMessage = 'Passwords don’t match yet';
        _isConfirmPasswordOk = false;
      });
      hasError = true;
    }

    if (hasError) return;

    final panNo = _accountType == 'Registered' && _gstinController.text.length >= 12
        ? _gstinController.text.substring(2, 12).toUpperCase()
        : 'ABCDE1234F';

    final success = await ref.read(registerNotifierProvider.notifier).register(
          signupToken: 'token_dummy_123',
          panNo: panNo,
          companyName: _companyController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: email,
          password: pw,
          passwordConfirmation: pw2,
          referralCode: _referralController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      setState(() {
        _step = 3;
      });
      ref.read(registerNotifierProvider.notifier).setStep(2);
    } else {
      final err = ref.read(registerNotifierProvider).errorMessage ?? 'Registration failed. Please try again.';
      context.showSnackBar(err, isError: true);
    }
  }

  void _onCtaPressed() {
    if (_step == 1) {
      _handleStep1Continue();
    } else if (_step == 2) {
      _handleStep2Register();
    } else {
      context.go(AppRouter.login);
    }
  }

  void _onBack() {
    if (_step > 1) {
      setState(() {
        _step--;
      });
      ref.read(registerNotifierProvider.notifier).setStep(_step - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registerNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? ColorManager.authBgDark : ColorManager.authBgLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar (Back button, App brand mark & name, 1/2 Pill)
                RegisterTopBar(
                  currentStep: _step,
                  appName: StringManager.appTitle,
                  onBack: _onBack,
                ),

                // Header (Title & Subtitle)
                RegisterHeaderNew(
                  currentStep: _step,
                ),

                // Live Digital Business ID / GST Card Preview (Steps 1 & 2)
                if (_step < 3)
                  BusinessIdCardPreview(
                    companyName: _companyController.text,
                    gstin: _gstinController.text,
                    ownerName: '${_firstNameController.text} ${_lastNameController.text}'.trim(),
                    phoneNumber: _phoneController.text,
                    isRegistered: _accountType == 'Registered',
                    isVerified: _isGstinVerified,
                    triggerShine: _triggerShine,
                  ),

                // Scrollable Form Pane
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    physics: const BouncingScrollPhysics(),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _step == 1
                          ? RegisterBusinessPane(
                              key: const ValueKey(1),
                              gstinController: _gstinController,
                              companyController: _companyController,
                              firstNameController: _firstNameController,
                              lastNameController: _lastNameController,
                              accountType: _accountType,
                              onAccountTypeChanged: (type) {
                                setState(() {
                                  _accountType = type;
                                  if (type == 'Unregistered') {
                                    _gstinErrorMessage = null;
                                  }
                                });
                                ref.read(registerNotifierProvider.notifier).setAccountType(type);
                              },
                              isGstinVerified: _isGstinVerified,
                              isVerifyingGstin: _isVerifyingGstin,
                              onVerifyGstin: _handleVerifyGstin,
                              gstinErrorMessage: _gstinErrorMessage,
                              isGstinMessageOk: _isGstinMessageOk,
                              companyErrorMessage: _companyErrorMessage,
                              firstNameErrorMessage: _firstNameErrorMessage,
                              lastNameErrorMessage: _lastNameErrorMessage,
                            )
                          : _step == 2
                              ? RegisterSecurityPane(
                                  key: const ValueKey(2),
                                  emailController: _emailController,
                                  phoneController: _phoneController,
                                  passwordController: _passwordController,
                                  confirmPasswordController: _confirmPasswordController,
                                  referralController: _referralController,
                                  obscurePassword: regState.obscurePassword,
                                  obscureConfirmPassword: regState.obscureConfirmPassword,
                                  onTogglePassword: () => ref
                                      .read(registerNotifierProvider.notifier)
                                      .toggleObscurePassword(),
                                  onToggleConfirmPassword: () => ref
                                      .read(registerNotifierProvider.notifier)
                                      .toggleObscureConfirmPassword(),
                                  emailErrorMessage: _emailErrorMessage,
                                  phoneErrorMessage: _phoneErrorMessage,
                                  passwordErrorMessage: _passwordErrorMessage,
                                  confirmPasswordMessage: _confirmPasswordMessage,
                                  isConfirmPasswordOk: _isConfirmPasswordOk,
                                )
                              : RegisterSuccessPane(
                                  key: const ValueKey(3),
                                  firstName: _firstNameController.text,
                                  companyName: _companyController.text,
                                ),
                    ),
                  ),
                ),

                // Sticky Bottom Dock with stylized button & sign in link
                RegisterBottomDock(
                  currentStep: _step,
                  isLoading: regState.isLoading,
                  onCtaPressed: _onCtaPressed,
                  onSignInTap: () => context.go(AppRouter.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
