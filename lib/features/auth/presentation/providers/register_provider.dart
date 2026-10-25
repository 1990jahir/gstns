import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/gstin_lookup_model.dart';
import '../../data/models/register_flow_models.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_provider.dart';

/// State class for Registration process
class RegisterState {
  final int currentStep; // 0 for Business Info, 1 for Personal Info
  final String accountType; // 'Registered' or 'Unregistered'
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final String? errorMessage;
  final bool isVerifyingGstin;
  final bool isGstinVerified;
  final String? gstinMessage;
  final bool isGstinMessageOk;
  final GstinLookupData? gstinData;

  // Multi-step OTP and Sign-up state
  final String? otpSessionToken;
  final String? signupToken;
  final int resendIn;
  final String? registeredMobile;
  final RegisterPayload? pendingPayload;
  final RegisterAccountResponse? accountResponse;

  RegisterState({
    this.currentStep = 0,
    this.accountType = 'Registered',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isLoading = false,
    this.errorMessage,
    this.isVerifyingGstin = false,
    this.isGstinVerified = false,
    this.gstinMessage,
    this.isGstinMessageOk = false,
    this.gstinData,
    this.otpSessionToken,
    this.signupToken,
    this.resendIn = 60,
    this.registeredMobile,
    this.pendingPayload,
    this.accountResponse,
  });

  RegisterState copyWith({
    int? currentStep,
    String? accountType,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isLoading,
    String? errorMessage,
    bool? isVerifyingGstin,
    bool? isGstinVerified,
    String? gstinMessage,
    bool? isGstinMessageOk,
    GstinLookupData? gstinData,
    String? otpSessionToken,
    String? signupToken,
    int? resendIn,
    String? registeredMobile,
    RegisterPayload? pendingPayload,
    RegisterAccountResponse? accountResponse,
  }) {
    return RegisterState(
      currentStep: currentStep ?? this.currentStep,
      accountType: accountType ?? this.accountType,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isVerifyingGstin: isVerifyingGstin ?? this.isVerifyingGstin,
      isGstinVerified: isGstinVerified ?? this.isGstinVerified,
      gstinMessage: gstinMessage,
      isGstinMessageOk: isGstinMessageOk ?? this.isGstinMessageOk,
      gstinData: gstinData ?? this.gstinData,
      otpSessionToken: otpSessionToken ?? this.otpSessionToken,
      signupToken: signupToken ?? this.signupToken,
      resendIn: resendIn ?? this.resendIn,
      registeredMobile: registeredMobile ?? this.registeredMobile,
      pendingPayload: pendingPayload ?? this.pendingPayload,
      accountResponse: accountResponse ?? this.accountResponse,
    );
  }
}

/// Notifier to manage registration state and actions
class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthRepository _repository;

  RegisterNotifier(this._repository) : super(RegisterState());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setAccountType(String type) {
    state = state.copyWith(accountType: type);
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void resetGstinVerification() {
    state = state.copyWith(
      isGstinVerified: false,
      gstinMessage: null,
      isGstinMessageOk: false,
      gstinData: null,
    );
  }

  /// Solves the bot challenge and looks up GSTIN from the registration endpoint
  Future<GstinLookupData?> lookupRegisterGstin(String gstin) async {
    state = state.copyWith(
      isVerifyingGstin: true,
      gstinMessage: null,
      isGstinMessageOk: false,
    );
    try {
      final data = await _repository.lookupRegisterGstin(gstin);

      if (data.alreadyRegistered) {
        state = state.copyWith(
          isVerifyingGstin: false,
          isGstinVerified: false,
          gstinMessage: 'This GSTIN already has an account. Please log in.',
          isGstinMessageOk: false,
          gstinData: null,
        );
        return null;
      }

      state = state.copyWith(
        isVerifyingGstin: false,
        isGstinVerified: true,
        gstinMessage: '✓ GST verified: ',
        isGstinMessageOk: true,
        gstinData: data,
      );
      return data;
    } catch (e) {
      state = state.copyWith(
        isVerifyingGstin: false,
        isGstinVerified: false,
        gstinMessage: e.toString().replaceAll('Exception: ', ''),
        isGstinMessageOk: false,
        gstinData: null,
      );
      return null;
    }
  }

  /// Sign-up Step 1: Request PoW challenge and send WhatsApp OTP
  Future<bool> sendRegisterOtp({
    required String mobile,
    required RegisterPayload payload,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.sendRegisterOtp(mobile);
      state = state.copyWith(
        isLoading: false,
        otpSessionToken: data.otpSessionToken,
        resendIn: data.resendIn,
        registeredMobile: mobile,
        pendingPayload: payload,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Resend WhatsApp OTP with fresh challenge
  Future<bool> resendRegisterOtp() async {
    if (state.registeredMobile == null) return false;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.sendRegisterOtp(state.registeredMobile!);
      state = state.copyWith(
        isLoading: false,
        otpSessionToken: data.otpSessionToken,
        resendIn: data.resendIn,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Sign-up Steps 2 & 3:
  /// 1. Solves challenge -> Verifies WhatsApp OTP -> gets signup_token
  /// 2. Solves challenge -> Creates account via POST /api/v1/register
  Future<bool> verifyRegisterOtpAndComplete({required String otp}) async {
    if (state.otpSessionToken == null || state.pendingPayload == null) {
      state = state.copyWith(errorMessage: 'Session expired. Please request a new OTP.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Verify OTP with fresh challenge
      final verifyData = await _repository.verifyRegisterOtp(
        otpSessionToken: state.otpSessionToken!,
        otp: otp,
      );

      // 2. Prepare final registration payload with verified signup_token
      final pending = state.pendingPayload!;
      final finalPayload = RegisterPayload(
        signupToken: verifyData.signupToken,
        userType: pending.userType,
        companyName: pending.companyName,
        firstName: pending.firstName,
        lastName: pending.lastName,
        email: pending.email,
        password: pending.password,
        passwordConfirmation: pending.passwordConfirmation,
        referralCode: pending.referralCode,
        gstin: pending.gstin,
        panNo: pending.panNo,
      );

      // 3. Complete registration with fresh challenge
      final accountRes = await _repository.registerAccount(finalPayload);

      state = state.copyWith(
        isLoading: false,
        signupToken: verifyData.signupToken,
        accountResponse: accountRes,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Legacy register method
  Future<bool> register({
    required String signupToken,
    required String panNo,
    required String companyName,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String referralCode = '',
    String? gstin,
    int? userType,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = {
        'signup_token': signupToken,
        'user_type': userType ?? (state.accountType == 'Registered' ? 3 : 7),
        if (state.accountType == 'Registered' && gstin != null && gstin.isNotEmpty) 'gstin': gstin,
        if (state.accountType != 'Registered' || gstin == null || gstin.isEmpty) 'pan_no': panNo,
        'company_name': companyName,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'referral_code': referralCode,
      };
      final res = await _repository.register(data);
      state = state.copyWith(isLoading: false);
      return res['status'] == 'success';
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final registerNotifierProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterNotifier(repository);
});
