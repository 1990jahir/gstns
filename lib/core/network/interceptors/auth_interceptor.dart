import 'package:dio/dio.dart';
import '../api_endpoints.dart';

/// Interceptor managing Basic Auth for auth endpoints (using exact Postman code snippet token)
/// and Bearer tokens for authenticated endpoints, with automatic token refreshing on 401 Unauthorized.
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  static String? accessToken;
  static String? refreshToken;

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/token/refresh') ||
        options.path.contains('/auth/otp/send') ||
        options.path.contains('/auth/otp/verify')) {
      options.headers['Authorization'] = 'Basic ${ApiEndpoints.basicAuthToken}';
    } else if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && refreshToken != null) {
      try {
        final success = await _refreshTokenCall();
        if (success) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $accessToken';
          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        }
      } catch (_) {
        accessToken = null;
        refreshToken = null;
      }
    }
    super.onError(err, handler);
  }

  Future<bool> _refreshTokenCall() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        accessToken = data['access_token'];
        refreshToken = data['refresh_token'];
        return true;
      }
    } catch (_) {}
    return false;
  }
}
