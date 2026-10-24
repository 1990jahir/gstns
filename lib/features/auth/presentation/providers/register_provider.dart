import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_provider.dart';

/// State class for Registration process
class RegisterState {
  final int currentStep; // 0 for Business Info, 1 for Personal Info
  final String accountType;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final String? errorMessage;

  RegisterState({
    this.currentStep = 0,
    this.accountType = 'Registered',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    int? currentStep,
    String? accountType,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      currentStep: currentStep ?? this.currentStep,
      accountType: accountType ?? this.accountType,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
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
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = {
        "signup_token": signupToken,
        "user_type": 7,
        "pan_no": panNo,
        "company_name": companyName,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "referral_code": referralCode,
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
