import 'package:flutter/foundation.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/challenge_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/auth_models.dart';
import '../../data/models/gstin_lookup_model.dart';
import '../../data/models/register_flow_models.dart';

/// Repository managing authentication operations, bot-check challenges, and local token caching.
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final CacheService _cacheService = CacheService();
  final ChallengeService _challengeService = ChallengeService();

  /// Standard Email & Password Login with Bot-Check PoW Challenge
  Future<AuthResponse> login(String email, String password) async {
    try {
      // 1. Solve Proof-of-Work bot-check challenge
      ChallengeSolution? solution;
      try {
        solution = await _challengeService.getSolvedChallenge();
      } catch (e) {
        debugPrint('[GSTSOF_AUTH] Challenge failed: ');
      }

      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(
        request,
        challenge: solution?.challenge,
        challengeNonce: solution?.nonce,
      );
      
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

  /// Solves the bot-check Proof-of-Work challenge off-thread and queries the registration GSTIN lookup API
  Future<GstinLookupData> lookupRegisterGstin(String gstin) async {
    try {
      // 1. Obtain solved bot-check challenge
      final solution = await _challengeService.getSolvedChallenge();

      // 2. Query GSTIN Lookup API with challenge headers
      final res = await _remoteDataSource.lookupRegisterGstin(
        gstin: gstin.trim().toUpperCase(),
        challenge: solution.challenge,
        nonce: solution.nonce,
      );

      if (res['data'] != null) {
        return GstinLookupData.fromJson(res['data'] as Map<String, dynamic>);
      }
      throw ApiException(message: res['message'] ?? 'GSTIN lookup failed');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Sign-up Step 1: Request a fresh PoW challenge and send WhatsApp OTP
  Future<RegisterOtpSendData> sendRegisterOtp(String mobile) async {
    try {
      // 1. Ensure E.164 phone format (+91 followed by 10 digits)
      final digits = mobile.replaceAll(RegExp(r'[^0-9]'), '');
      final last10 = digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
      final formatted = '+91$last10';

      // 2. Obtain fresh solved bot-check challenge
      final solution = await _challengeService.getSolvedChallenge();

      // 3. Send WhatsApp OTP
      final res = await _remoteDataSource.sendRegisterOtp(
        mobile: formatted,
        challenge: solution.challenge,
        nonce: solution.nonce,
      );

      if (res['data'] != null) {
        return RegisterOtpSendData.fromJson(res['data'] as Map<String, dynamic>);
      }
      throw ApiException(message: res['message'] ?? 'Failed to send WhatsApp OTP');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Sign-up Step 2: Request a fresh PoW challenge and verify WhatsApp OTP
  Future<RegisterOtpVerifyData> verifyRegisterOtp({
    required String otpSessionToken,
    required String otp,
  }) async {
    try {
      // 1. Obtain fresh solved bot-check challenge
      final solution = await _challengeService.getSolvedChallenge();

      // 2. Verify WhatsApp OTP
      final res = await _remoteDataSource.verifyRegisterOtp(
        otpSessionToken: otpSessionToken,
        otp: otp.trim(),
        challenge: solution.challenge,
        nonce: solution.nonce,
      );

      if (res['data'] != null) {
        return RegisterOtpVerifyData.fromJson(res['data'] as Map<String, dynamic>);
      }
      throw ApiException(message: res['message'] ?? 'Failed to verify WhatsApp OTP');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Sign-up Step 3: Request a fresh PoW challenge and create the account
  Future<RegisterAccountResponse> registerAccount(RegisterPayload payload) async {
    try {
      // 1. Obtain fresh solved bot-check challenge
      final solution = await _challengeService.getSolvedChallenge();

      // 2. Create Account
      final res = await _remoteDataSource.register(
        payload.toJson(),
        challenge: solution.challenge,
        challengeNonce: solution.nonce,
      );

      final accountRes = RegisterAccountResponse.fromJson(res);

      // If login_required is false, session tokens are provided immediately
      if (!accountRes.loginRequired && accountRes.accessToken != null && accountRes.accessToken!.isNotEmpty) {
        AuthInterceptor.setTokens(
          access: accountRes.accessToken!,
          refresh: accountRes.refreshToken ?? '',
        );
        await _cacheService.saveAuthSession(
          accessToken: accountRes.accessToken!,
          refreshToken: accountRes.refreshToken ?? '',
          email: payload.email,
        );
      }

      return accountRes;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Legacy helper for backward compatibility
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      ChallengeSolution? solution;
      try {
        solution = await _challengeService.getSolvedChallenge();
      } catch (_) {}

      final response = await _remoteDataSource.register(
        data,
        challenge: solution?.challenge ?? '',
        challengeNonce: solution?.nonce ?? '',
      );

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

  /// Legacy helper for backward compatibility
  Future<Map<String, dynamic>> verifyGstin(String gstin) async {
    try {
      final data = await lookupRegisterGstin(gstin);
      return {
        'status': 'success',
        'data': data.toJson(),
      };
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
