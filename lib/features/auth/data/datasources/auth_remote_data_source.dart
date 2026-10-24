import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../models/auth_models.dart';

/// Remote Data Source handling authentication network requests using ApiClient.
class AuthRemoteDataSource {
  final Dio _dio = ApiClient().dio;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
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

  Future<Map<String, dynamic>> verifyGstin(String gstin) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyGstin,
        data: {"gstin": gstin},
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data, {String? challenge, String? challengeNonce}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: data,
        options: Options(
          headers: {
            if (challenge != null) ...{'X-Challenge': challenge},
            if (challengeNonce != null) ...{'X-Challenge-Nonce': challengeNonce},
          },
        ),
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
