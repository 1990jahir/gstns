import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import '../providers/register_provider.dart';

/// Modern WhatsApp OTP Verification Page for Registration & Login flows.
/// Features:
/// - 6-digit individual PIN input boxes with auto-advance and backspace handling
/// - Live WhatsApp OTP resend countdown timer (resend_in cooldown)
/// - Integrated Proof-of-Work Bot-Check challenge solving
/// - Two-in-one execution: Verifies WhatsApp OTP and automatically completes account creation
class VerifyOtpPage extends ConsumerStatefulWidget {
  final String mobile;
  const VerifyOtpPage({super.key, this.mobile = ''});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _countdownTimer;
  int _secondsRemaining = 60;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    final regState = ref.read(registerNotifierProvider);
    _secondsRemaining = regState.resendIn > 0 ? regState.resendIn : 60;
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp {
    return _controllers.map((c) => c.text).join();
  }

  void _clearOtp() {
    for (var c in _controllers) {
      c.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _onResendOtp() async {
    if (_secondsRemaining > 0 || _isResending) return;

    setState(() => _isResending = true);
    final success = await ref.read(registerNotifierProvider.notifier).resendRegisterOtp();
    if (!mounted) return;

    setState(() => _isResending = false);

    if (success) {
      final regState = ref.read(registerNotifierProvider);
      setState(() {
        _secondsRemaining = regState.resendIn > 0 ? regState.resendIn : 60;
      });
      _startCountdown();
      context.showSnackBar('A new 6-digit OTP has been sent on WhatsApp.');
    } else {
      final err = ref.read(registerNotifierProvider).errorMessage ?? 'Could not resend OTP. Please wait and try again.';
      context.showSnackBar(err, isError: true);
    }
  }

  Future<void> _onVerify() async {
    final otp = _enteredOtp.trim();
    if (otp.length < 6) {
      context.showSnackBar(StringManager.completeOtpRequired, isError: true);
      return;
    }

    final regState = ref.read(registerNotifierProvider);

    // Flow A: Multi-step Registration OTP & Account Creation Flow
    if (regState.otpSessionToken != null && regState.pendingPayload != null) {
      final success = await ref.read(registerNotifierProvider.notifier).verifyRegisterOtpAndComplete(otp: otp);
      if (!mounted) return;

      if (success) {
        final accountRes = ref.read(registerNotifierProvider).accountResponse;
        if (accountRes != null && !accountRes.loginRequired) {
          context.showSnackBar('Registration successful! Welcome to GSTSOF.');
          context.go(AppRouter.dashboard);
        } else {
          context.showSnackBar('Account created successfully! Please log in.', isError: false);
          context.go(AppRouter.login);
        }
      } else {
        final err = ref.read(registerNotifierProvider).errorMessage ?? 'Invalid OTP code. Please try again.';
        context.showSnackBar(err, isError: true);
        _clearOtp();
      }
      return;
    }

    // Flow B: Standalone WhatsApp Login OTP Flow (Method B)
    try {
      final repository = ref.read(authRepositoryProvider);
      final res = await repository.verifyOtp(regState.otpSessionToken ?? 'session_token', otp);
      if (!mounted) return;

      if (res.status == 'success') {
        context.showSnackBar(StringManager.otpVerifiedSuccessfully);
        context.go(AppRouter.dashboard);
      } else {
        context.showSnackBar(res.message ?? StringManager.invalidOtp, isError: true);
        _clearOtp();
      }
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      _clearOtp();
    }
  }

  String _formatPhoneNumber(String raw) {
    if (raw.isEmpty) return 'your registered number';
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 10) {
      final last10 = digits.substring(digits.length - 10);
      return '+91 ${last10.substring(0, 5)} ${last10.substring(5)}';
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(registerNotifierProvider);
    final targetMobile = widget.mobile.isNotEmpty
        ? widget.mobile
        : (regState.registeredMobile ?? '');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () {
            ref.read(registerNotifierProvider.notifier).clearError();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryGreen.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // WhatsApp Badge Icon
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/png_images/whatsapp.png',
                            width: 34,
                            height: 34,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.message_rounded,
                              size: 32,
                              color: Color(0xFF25D366),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Verify WhatsApp OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle with target formatted mobile
                    Text(
                      'We have sent a 6-digit one-time password to your WhatsApp at\n${_formatPhoneNumber(targetMobile)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontFamily: 'Inter',
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 6-Digit PIN Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 48,
                          height: 56,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: ColorManager.primaryGreen, width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                              if (_enteredOtp.length == 6) {
                                _onVerify();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    // Inline Error Banner if failed
                    if (regState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                regState.errorMessage!,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Verify Button
                    CustomButton(
                      text: 'Verify & Create Account',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: regState.isLoading,
                      onPressed: regState.isLoading ? null : _onVerify,
                    ),
                    const SizedBox(height: 20),

                    // Resend OTP Row with Live Cooldown Timer
                    Center(
                      child: _secondsRemaining > 0
                          ? Text(
                              'Resend code in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            )
                          : TextButton.icon(
                              onPressed: _isResending ? null : _onResendOtp,
                              icon: _isResending
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: ColorManager.primaryGreen),
                                    )
                                  : const Icon(Icons.refresh_rounded, size: 16, color: ColorManager.primaryGreen),
                              label: Text(
                                _isResending ? 'Sending...' : 'Resend OTP on WhatsApp',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                  color: ColorManager.primaryGreen,
                                ),
                              ),
                            ),
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
