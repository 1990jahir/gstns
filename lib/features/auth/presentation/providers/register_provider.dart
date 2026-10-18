import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for Registration process
class RegisterState {
  final int currentStep; // 0 for Business Info, 1 for Personal Info
  final String accountType;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;

  RegisterState({
    this.currentStep = 0,
    this.accountType = 'Registered',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isLoading = false,
  });

  RegisterState copyWith({
    int? currentStep,
    String? accountType,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isLoading,
  }) {
    return RegisterState(
      currentStep: currentStep ?? this.currentStep,
      accountType: accountType ?? this.accountType,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier to manage registration state and actions
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

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
}

final registerNotifierProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});
