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
        await _cacheService.saveAuthSession(
          accessToken: tokenData['access_token'] ?? '',
          refreshToken: tokenData['refresh_token'] ?? '',
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

  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {}
    await _cacheService.clearSession();
  }
}
