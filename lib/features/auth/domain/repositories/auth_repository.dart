import '../../../../core/network/api_exception.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';
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
        AuthInterceptor.setTokens(
          access: response.data!.accessToken,
          refresh: response.data!.refreshToken,
        );
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

  Future<Map<String, dynamic>> verifyGstin(String gstin) async {
    try {
      return await _remoteDataSource.verifyGstin(gstin);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      String? challenge;
      String? challengeNonce;
      try {
        final challengeRes = await _remoteDataSource.getChallenge();
        if (challengeRes['data'] != null) {
          challenge = challengeRes['data']['challenge'];
          challengeNonce = challengeRes['data']['nonce'];
        }
      } catch (_) {}

      final response = await _remoteDataSource.register(data, challenge: challenge, challengeNonce: challengeNonce);

      if (response['status'] == 'success' && response['data'] != null && response['data']['login_required'] == false) {
        final tokenData = response['data'];
        final accessToken = tokenData['access_token'] ?? '';
        final refreshToken = tokenData['refresh_token'] ?? '';
        AuthInterceptor.setTokens(
          access: accessToken,
          refresh: refreshToken,
        );
        await _cacheService.saveAuthSession(
          accessToken: accessToken,
          refreshToken: refreshToken,
          email: data['email'] ?? '',
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
        AuthInterceptor.setTokens(
          access: response.data!.accessToken,
          refresh: response.data!.refreshToken,
        );
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

  Future<AuthResponse> getMe() async {
    try {
      return await _remoteDataSource.getMe();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  bool _isLoggingOut = false;

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      if (AuthInterceptor.accessToken != null && AuthInterceptor.accessToken!.isNotEmpty) {
        await _remoteDataSource.logout();
      }
    } catch (_) {
    } finally {
      AuthInterceptor.clearTokens();
      await _cacheService.clearSession();
      _isLoggingOut = false;
    }
  }
}
