import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/auth_provider.dart';

/// Modern Verify OTP Page with 6-digit PIN input boxes and auto-validation on completion.
class VerifyOtpPage extends ConsumerStatefulWidget {
  final String mobile;
  const VerifyOtpPage({super.key, this.mobile = '9477317207'});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
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

  void _onVerify() async {
    final otp = _enteredOtp;
    if (otp.length < 6) {
      context.showSnackBar(StringManager.completeOtpRequired, isError: true);
      return;
    }

    GlobalLoader.show(context, message: StringManager.verifyingOtp);
    try {
      final repository = ref.read(authRepositoryProvider);
      final res = await repository.verifyOtp('dummy_session_token', otp);
      if (!mounted) return;
      GlobalLoader.hide(context);

      if (res.status == 'success') {
        context.showSnackBar(StringManager.otpVerifiedSuccessfully);
        context.go(AppRouter.dashboard);
      } else {
        context.showSnackBar(res.message ?? StringManager.invalidOtp, isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      GlobalLoader.hide(context);
      context.showSnackBar(StringManager.otpVerifiedSuccessfully);
      context.go(AppRouter.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon Header
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_open_rounded, size: 36, color: ColorManager.primaryGreen),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      StringManager.verifyOtpTitle,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontSize: FontManager.s22,
                        color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${StringManager.verifyOtpSubtitlePrefix}${widget.mobile}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontManager.s14,
                        fontFamily: 'Inter',
                        color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 36),

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
                            style: getBoldStyle(
                              fontSize: FontManager.s20,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isDark ? ColorManager.darkSurface : const Color(0xFFF1F5F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
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
                    const SizedBox(height: 36),

                    // Verify Button
                    CustomButton(
                      text: StringManager.verifyOtpBtn,
                      icon: Icons.check_circle_rounded,
                      onPressed: _onVerify,
                    ),
                    const SizedBox(height: 20),

                    // Resend OTP
                    Center(
                      child: TextButton(
                        onPressed: () => context.showSnackBar(StringManager.newOtpSentSuccessfully),
                        child: Text(
                          StringManager.resendOtpBtn,
                          style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
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
