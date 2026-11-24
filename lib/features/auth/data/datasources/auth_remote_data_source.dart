import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/auth_models.dart';

/// Remote Data Source handling authentication network requests using ApiClient.
class AuthRemoteDataSource {
  final Dio _dio = ApiClient().dio;

  Future<AuthResponse> login(LoginRequest request, {String? challenge, String? challengeNonce}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
        options: Options(
          headers: {
            'X-Challenge': ?challenge,
            'X-Challenge-Nonce': ?challengeNonce,
          },
        ),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> refreshToken(TokenRefreshRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.logout,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> sendOtp(OtpSendRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sendOtp,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> verifyOtp(OtpVerifyRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> getChallenge() async {
    try {
      final response = await _dio.post(ApiEndpoints.challenge);
      return response.data;
    } catch (_) {
      try {
        final response = await _dio.get(ApiEndpoints.challenge);
        return response.data;
      } on DioException catch (e) {
        throw ApiException.fromDioException(e);
      }
    }
  }

  /// Sign-up: Check if email, mobile, PAN or GSTIN is free
  /// POST /api/v1/register/check
  Future<Map<String, dynamic>> checkAvailability({
    required Map<String, dynamic> data,
    required String challenge,
    required String nonce,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerCheck,
        data: data,
        options: Options(
          headers: {
            'X-Challenge': challenge,
            'X-Challenge-Nonce': nonce,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Sign-up: GSTIN Lookup before login
  /// POST /api/v1/register/gstin-lookup
  Future<Map<String, dynamic>> lookupRegisterGstin({
    required String gstin,
    required String challenge,
    required String nonce,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerGstinLookup,
        data: {'gstin': gstin},
        options: Options(
          headers: {
            'X-Challenge': challenge,
            'X-Challenge-Nonce': nonce,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Sign-up Step 1: Send WhatsApp OTP to mobile number
  /// POST /api/v1/register/otp/send
  Future<Map<String, dynamic>> sendRegisterOtp({
    required String mobile,
    required String challenge,
    required String nonce,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerOtpSend,
        data: {'mobile': mobile},
        options: Options(
          headers: {
            'X-Challenge': challenge,
            'X-Challenge-Nonce': nonce,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Sign-up Step 2: Verify WhatsApp OTP and receive signup_token
  /// POST /api/v1/register/otp/verify
  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String otpSessionToken,
    required String otp,
    required String challenge,
    required String nonce,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerOtpVerify,
        data: {
          'otp_session_token': otpSessionToken,
          'otp': otp,
        },
        options: Options(
          headers: {
            'X-Challenge': challenge,
            'X-Challenge-Nonce': nonce,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Sign-up Step 3: Create the account and get session tokens
  /// POST /api/v1/register
  Future<Map<String, dynamic>> register(
    Map<String, dynamic> data, {
    required String challenge,
    required String challengeNonce,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: data,
        options: Options(
          headers: {
            'X-Challenge': challenge,
            'X-Challenge-Nonce': challengeNonce,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Legacy helper for backward compatibility
  Future<Map<String, dynamic>> verifyGstin(String gstin) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyGstin,
        data: {'gstin': gstin},
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResponse> getMe() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
