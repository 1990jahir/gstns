import '../../../../core/network/api_exception.dart';
import '../../../../core/services/cache_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/auth_models.dart';

/// Repository managing authentication operations and local token caching.
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final CacheService _cacheService = CacheService();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);
      
      if (response.status == 'success' && response.data != null) {
        await _cacheService.saveAuthSession(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken,
          email: email,
        );
      }
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<AuthResponse> sendOtp(String mobile) async {
    try {
      final request = OtpSendRequest(mobile: mobile);
      return await _remoteDataSource.sendOtp(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<AuthResponse> verifyOtp(String sessionToken, String otp) async {
    try {
      final request = OtpVerifyRequest(otpSessionToken: sessionToken, otp: otp);
      final response = await _remoteDataSource.verifyOtp(request);

      if (response.status == 'success' && response.data != null) {
        await _cacheService.saveAuthSession(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken,
          email: response.data!.user?.email ?? '',
        );
      }
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> logout() async {
    await _cacheService.clearSession();
  }
}
