import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme provider to toggle between Light and Dark themes
final themeModeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark

class AuthState {
  final bool obscurePassword;
  final bool rememberMe;
  final bool isLoading;

  AuthState({
    this.obscurePassword = true,
    this.rememberMe = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? obscurePassword,
    bool? rememberMe,
    bool? isLoading,
  }) {
    return AuthState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? !state.rememberMe);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier();
  return notifier;
});
