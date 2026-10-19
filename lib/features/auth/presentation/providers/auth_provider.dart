import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for AuthRepository singleton instance.
final authRepositoryProvider = Provider((ref) => AuthRepository());

// Theme provider to toggle between Light and Dark themes
final themeModeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark

class AuthState {
  final bool obscurePassword;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.obscurePassword = true,
    this.rememberMe = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? obscurePassword,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? !state.rememberMe);
  }

  /// Performs real API login via AuthRepository
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _repository.login(email, password);
      state = state.copyWith(isLoading: false);
      return response.status == 'success';
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
