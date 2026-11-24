import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/register_flow_models.dart';
import '../providers/register_provider.dart';
import '../widgets/auth_role_segmented_switch.dart';
import '../widgets/business_id_card_preview.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/register_bottom_dock.dart';
import '../widgets/register_business_pane.dart';
import '../widgets/register_header_new.dart';
import '../widgets/register_partner_pane.dart';
import '../widgets/register_security_pane.dart';
import '../widgets/register_top_bar.dart';

/// Modern Revamped Multi-step Register Page supporting both Business Client and CA/Tax Partner roles.
class RegisterPage extends ConsumerStatefulWidget {
  final String? initialRole;
  const RegisterPage({super.key, this.initialRole});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // Role switcher: 0 = Client, 1 = Partner (CA/Tax Professional)
  late int _roleIndex;

  // Step tracker: 1 = Business Info, 2 = Security Credentials
  int _step = 1;

  // Client Controllers
  final _gstinController = TextEditingController();
  final _companyController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  // Partner Controllers
  final _partnerFullNameController = TextEditingController();
  final _partnerFirmNameController = TextEditingController();
  final _partnerMembershipController = TextEditingController();
  final _partnerEmailController = TextEditingController();
  final _partnerPhoneController = TextEditingController();
  final _partnerPasswordController = TextEditingController();
  final _partnerConfirmPasswordController = TextEditingController();
  final _partnerCityController = TextEditingController();
  final _partnerStateController = TextEditingController();

  // Partner State
  String _partnerProfession = 'Chartered Accountant (CA)';

  // Client Step 1 Validation & Card State
  String _accountType = 'Registered';
  bool _isGstinVerified = false;
  bool _isVerifyingGstin = false;
  bool _triggerShine = false;
  String? _gstinErrorMessage;
  bool _isGstinMessageOk = false;
  String? _companyErrorMessage;
  String? _firstNameErrorMessage;
  String? _lastNameErrorMessage;

  // Client Step 2 Validation & State
  String? _emailErrorMessage;
  String? _phoneErrorMessage;
  String? _passwordErrorMessage;
  String? _confirmPasswordMessage;
  bool _isConfirmPasswordOk = false;

  // Partner Validation & State
  String? _partnerProfessionError;
  String? _partnerMembershipError;
  String? _partnerFirmNameError;
  String? _partnerCityError;
  String? _partnerStateError;
  String? _partnerFullNameError;
  String? _partnerEmailError;
  String? _partnerPhoneError;
  String? _partnerPasswordError;
  String? _partnerConfirmPasswordError;

  static final RegExp _gstRegex = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$');
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRegex = RegExp(r'^[6-9]\d{9}$');

  @override
  void initState() {
    super.initState();
    _roleIndex = widget.initialRole == 'partner' ? 1 : 0;
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

    _partnerFullNameController.dispose();
    _partnerFirmNameController.dispose();
    _partnerMembershipController.dispose();
    _partnerEmailController.dispose();
    _partnerPhoneController.dispose();
    _partnerPasswordController.dispose();
    _partnerConfirmPasswordController.dispose();
    _partnerCityController.dispose();
    _partnerStateController.dispose();
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
        _gstinErrorMessage = StringManager.gstinFormatError;
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
        _confirmPasswordMessage = StringManager.passwordsDoNotMatch;
        _isConfirmPasswordOk = true;
      });
    } else {
      setState(() {
        _confirmPasswordMessage = StringManager.passwordsDoNotMatch;
        _isConfirmPasswordOk = false;
      });
    }
  }

  Future<void> _handleVerifyGstin() async {
    final gstin = _gstinController.text.trim().toUpperCase();
    if (gstin.length != 15 || !_gstRegex.hasMatch(gstin)) {
      setState(() {
        _gstinErrorMessage = StringManager.gstinFormatError;
        _isGstinMessageOk = false;
      });
      return;
    }

    setState(() {
      _isVerifyingGstin = true;
      _gstinErrorMessage = null;
    });

    final details = await ref.read(registerNotifierProvider.notifier).verifyGstin(gstin);

    if (!mounted) return;

    setState(() {
      _isVerifyingGstin = false;
      if (details != null) {
        _isGstinVerified = true;
        _gstinErrorMessage = StringManager.gstinVerifiedSuccessfully;
        _isGstinMessageOk = true;
        _triggerShine = true;

        if (details.companyName.isNotEmpty) {
          _companyController.text = details.companyName;
        } else if (details.tradeName.isNotEmpty) {
          _companyController.text = details.tradeName;
        } else if (details.legalName.isNotEmpty) {
          _companyController.text = details.legalName;
        }
        _companyErrorMessage = null;
      } else {
        final regState = ref.read(registerNotifierProvider);
        _gstinErrorMessage = regState.gstinMessage ?? 'Could not verify GSTIN';
        _isGstinMessageOk = false;
      }
    });

    if (_triggerShine) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _triggerShine = false);
      });
    }
  }

  void _handleStep1Continue() {
    bool hasError = false;

    if (_accountType == 'Registered') {
      final gstin = _gstinController.text.trim().toUpperCase();
      if (!_gstRegex.hasMatch(gstin)) {
        setState(() {
          _gstinErrorMessage = StringManager.gstinFormatError;
          _isGstinMessageOk = false;
        });
        hasError = true;
      }
    }

    if (_companyController.text.trim().isEmpty) {
      setState(() => _companyErrorMessage = StringManager.fieldRequired);
      hasError = true;
    } else {
      setState(() => _companyErrorMessage = null);
    }

    if (_firstNameController.text.trim().isEmpty) {
      setState(() => _firstNameErrorMessage = StringManager.fieldRequired);
      hasError = true;
    } else {
      setState(() => _firstNameErrorMessage = null);
    }

    if (_lastNameController.text.trim().isEmpty) {
      setState(() => _lastNameErrorMessage = StringManager.fieldRequired);
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
      setState(() => _emailErrorMessage = StringManager.emailInvalid);
      hasError = true;
    } else {
      setState(() => _emailErrorMessage = null);
    }

    final phone = _phoneController.text.trim();
    if (!_phoneRegex.hasMatch(phone)) {
      setState(() => _phoneErrorMessage = StringManager.enterValidPhone);
      hasError = true;
    } else {
      setState(() => _phoneErrorMessage = null);
    }

    final pw = _passwordController.text;
    final strength = PasswordStrengthMeter.calculateStrength(pw);
    if (strength < 2) {
      setState(() => _passwordErrorMessage = StringManager.passwordTooShort);
      hasError = true;
    } else {
      setState(() => _passwordErrorMessage = null);
    }

    final pw2 = _confirmPasswordController.text;
    if (pw != pw2) {
      setState(() {
        _confirmPasswordMessage = StringManager.passwordsDoNotMatch;
        _isConfirmPasswordOk = false;
      });
      hasError = true;
    }

    if (hasError) return;

    final gstinText = _gstinController.text.trim().toUpperCase();
    final panNo = gstinText.length >= 12 ? gstinText.substring(2, 12) : null;

    final payload = RegisterPayload(
      signupToken: 'token_dummy_123',
      userType: _accountType == 'Registered' ? 3 : 7,
      companyName: _companyController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: email,
      password: pw,
      passwordConfirmation: pw2,
      referralCode: _referralController.text.trim(),
      gstin: _accountType == 'Registered' ? gstinText : null,
      panNo: _accountType == 'Registered' ? null : panNo,
    );

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final last10 = digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
    final formattedMobile = '+91$last10';

    final success = await ref.read(registerNotifierProvider.notifier).sendRegisterOtp(
          mobile: formattedMobile,
          payload: payload,
        );

    if (!mounted) return;

    if (success) {
      context.push(AppRouter.verifyOtp, extra: formattedMobile);
    } else {
      final err = ref.read(registerNotifierProvider).errorMessage ?? 'Failed to send WhatsApp OTP. Please try again.';
      context.showSnackBar(err, isError: true);
    }
  }

  Future<void> _handlePartnerRegister() async {
    bool hasError = false;

    if (_partnerProfession.trim().isEmpty) {
      _partnerProfessionError = StringManager.professionRequired;
      hasError = true;
    } else {
      _partnerProfessionError = null;
    }

    if (_partnerMembershipController.text.trim().isEmpty) {
      _partnerMembershipError = StringManager.membershipRequired;
      hasError = true;
    } else {
      _partnerMembershipError = null;
    }

    if (_partnerFirmNameController.text.trim().isEmpty) {
      _partnerFirmNameError = StringManager.firmNameRequired;
      hasError = true;
    } else {
      _partnerFirmNameError = null;
    }

    if (_partnerCityController.text.trim().isEmpty) {
      _partnerCityError = StringManager.cityRequired;
      hasError = true;
    } else {
      _partnerCityError = null;
    }

    if (_partnerStateController.text.trim().isEmpty) {
      _partnerStateError = StringManager.stateRequired;
      hasError = true;
    } else {
      _partnerStateError = null;
    }

    final partnerName = _partnerFullNameController.text.trim();
    if (partnerName.isEmpty) {
      _partnerFullNameError = StringManager.partnerNameRequired;
      hasError = true;
    } else {
      _partnerFullNameError = null;
    }

    final email = _partnerEmailController.text.trim();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      _partnerEmailError = StringManager.emailInvalid;
      hasError = true;
    } else {
      _partnerEmailError = null;
    }

    final phone = _partnerPhoneController.text.trim();
    if (phone.isEmpty || !_phoneRegex.hasMatch(phone)) {
      _partnerPhoneError = StringManager.enterValidPhone;
      hasError = true;
    } else {
      _partnerPhoneError = null;
    }

    final pw = _partnerPasswordController.text;
    if (pw.isEmpty || pw.length < 6) {
      _partnerPasswordError = StringManager.passwordTooShort;
      hasError = true;
    } else {
      _partnerPasswordError = null;
    }

    final pw2 = _partnerConfirmPasswordController.text;
    if (pw2 != pw) {
      _partnerConfirmPasswordError = StringManager.passwordsDoNotMatch;
      hasError = true;
    } else {
      _partnerConfirmPasswordError = null;
    }

    setState(() {});

    if (hasError) return;

    final nameParts = partnerName.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Partner';

    final payload = RegisterPayload(
      signupToken: 'token_dummy_123',
      userType: 3, // Partner role / CA
      companyName: _partnerFirmNameController.text.trim(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: pw,
      passwordConfirmation: pw2,
      referralCode: _partnerMembershipController.text.trim(),
      gstin: null,
      panNo: null,
    );

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final last10 = digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
    final formattedMobile = '+91$last10';

    final success = await ref.read(registerNotifierProvider.notifier).sendRegisterOtp(
          mobile: formattedMobile,
          payload: payload,
        );

    if (!mounted) return;

    if (success) {
      context.push(AppRouter.verifyOtp, extra: formattedMobile);
    } else {
      final err = ref.read(registerNotifierProvider).errorMessage ?? 'Failed to send WhatsApp OTP. Please try again.';
      context.showSnackBar(err, isError: true);
    }
  }

  void _onCtaPressed() {
    if (_roleIndex == 1) {
      _handlePartnerRegister();
      return;
    }

    if (_step == 1) {
      _handleStep1Continue();
    } else {
      _handleStep2Register();
    }
  }

  void _onBack() {
    if (_roleIndex == 1) {
      setState(() => _roleIndex = 0);
      return;
    }
    if (_step > 1) {
      setState(() {
        _step--;
      });
      ref.read(registerNotifierProvider.notifier).setStep(_step - 1);
    } else {
      context.go(AppRouter.login);
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

                // Role Switcher Segmented Control (Business Client vs CA/Tax Partner)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                  child: AuthRoleSegmentedSwitch(
                    selectedRole: _roleIndex == 1 ? 'partner' : 'client',
                    onRoleChanged: (role) {
                      setState(() {
                        _roleIndex = role == 'partner' ? 1 : 0;
                        _step = 1;
                      });
                    },
                  ),
                ),

                // Header (Title & Subtitle)
                RegisterHeaderNew(
                  currentStep: _roleIndex == 1 ? 1 : _step,
                ),

                // Live Digital Business ID / GST Card Preview (Client Step 1 & 2)
                if (_roleIndex == 0 && _step < 3)
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
                      child: _roleIndex == 1
                          ? RegisterPartnerPane(
                              key: const ValueKey('partner_pane'),
                              fullNameController: _partnerFullNameController,
                              firmNameController: _partnerFirmNameController,
                              membershipController: _partnerMembershipController,
                              emailController: _partnerEmailController,
                              phoneController: _partnerPhoneController,
                              passwordController: _partnerPasswordController,
                              confirmPasswordController: _partnerConfirmPasswordController,
                              cityController: _partnerCityController,
                              stateController: _partnerStateController,
                              selectedProfession: _partnerProfession,
                              onProfessionChanged: (prof) => setState(() => _partnerProfession = prof),
                              obscurePassword: regState.obscurePassword,
                              obscureConfirmPassword: regState.obscureConfirmPassword,
                              onTogglePassword: () => ref.read(registerNotifierProvider.notifier).toggleObscurePassword(),
                              onToggleConfirmPassword: () => ref.read(registerNotifierProvider.notifier).toggleObscureConfirmPassword(),
                              fullNameError: _partnerFullNameError,
                              professionError: _partnerProfessionError,
                              firmNameError: _partnerFirmNameError,
                              membershipError: _partnerMembershipError,
                              emailError: _partnerEmailError,
                              phoneError: _partnerPhoneError,
                              passwordError: _partnerPasswordError,
                              confirmPasswordError: _partnerConfirmPasswordError,
                              cityError: _partnerCityError,
                              stateError: _partnerStateError,
                            )
                          : _step == 1
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
                              : RegisterSecurityPane(
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
                                ),
                    ),
                  ),
                ),

                // Sticky Bottom Dock with stylized button & sign in link
                RegisterBottomDock(
                  currentStep: _roleIndex == 1 ? 1 : _step,
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
