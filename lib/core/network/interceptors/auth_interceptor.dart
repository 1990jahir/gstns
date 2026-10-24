import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../res/string_manager.dart';
import '../../services/cache_service.dart';
import '../../services/connectivity_service.dart';
import '../../router/app_router.dart';
import '../api_endpoints.dart';
import '../api_exception.dart';

/// Interceptor managing Basic Auth for auth & register endpoints,
/// Bearer tokens for authenticated endpoints, connectivity checks,
/// and automatic mutex-protected token refreshing on 401 Unauthorized.
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  static String? accessToken;
  static String? refreshToken;

  /// Completer lock to queue and synchronize concurrent 401 requests during token refresh
  static Completer<bool>? _refreshCompleter;

  AuthInterceptor(this._dio);

  /// Synchronously sets the active in-memory tokens
  static void setTokens({required String access, required String refresh}) {
    accessToken = access;
    refreshToken = refresh;
  }

  /// Clears in-memory tokens upon logout or session termination
  static void clearTokens() {
    accessToken = null;
    refreshToken = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasInternet = await ConnectivityService().hasInternetConnection();
    if (!hasInternet) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: ApiException(message: StringManager.noInternetConnection),
          type: DioExceptionType.connectionError,
          message: StringManager.noInternetConnection,
        ),
      );
    }

    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/token/refresh') ||
        options.path.contains('/auth/otp/send') ||
        options.path.contains('/auth/otp/verify') ||
        options.path.contains('/auth/challenge') ||
        options.path.contains('/register') ||
        options.path.contains('/gstin/verify')) {
      options.headers['Authorization'] = 'Basic ${ApiEndpoints.basicAuthToken}';
    } else if (accessToken != null && accessToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    debugPrint('[GSTSOF_DEBUG] -> REQUEST [${options.method}] => PATH: ${options.path} | AUTH: ${options.headers['Authorization']}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isRefreshPath = err.requestOptions.path.contains(ApiEndpoints.refreshToken);
    final isLogoutPath = err.requestOptions.path.contains(ApiEndpoints.logout);
    final isRetry = err.requestOptions.extra['is_retry'] == true;

    // If 401 occurred on logout, do not refresh token - session is already terminated
    if (isLogoutPath) {
      await _handleSessionExpired();
      return handler.resolve(Response(
        requestOptions: err.requestOptions,
        statusCode: 200,
        data: {'status': 'success', 'message': 'Logged out locally'},
      ));
    }

    // If 401 occurred on the refresh token endpoint itself or an already retried request, terminate session
    if (statusCode == 401 && (isRefreshPath || isRetry)) {
      await _handleSessionExpired();
      return super.onError(err, handler);
    }

    // Standard 401 on an authenticated endpoint: attempt token refresh
    if (statusCode == 401 && refreshToken != null && refreshToken!.isNotEmpty) {
      try {
        bool refreshSuccess = false;

        // If another request is currently refreshing the token, await its completion (Mutex queue)
        if (_refreshCompleter != null) {
          refreshSuccess = await _refreshCompleter!.future;
        } else {
          // We are the first 401 request: lock the queue and execute the refresh call
          final completer = Completer<bool>();
          _refreshCompleter = completer;

          refreshSuccess = await _refreshTokenCall();
          completer.complete(refreshSuccess);
          _refreshCompleter = null;
        }

        if (refreshSuccess && accessToken != null && accessToken!.isNotEmpty) {
          // Clone request options, mark as retry, and inject the refreshed Bearer token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $accessToken';
          opts.extra['is_retry'] = true;

          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        } else {
          await _handleSessionExpired();
        }
      } catch (e) {
        debugPrint('[GSTSOF_DEBUG] -> Error handling 401 token refresh: $e');
        _refreshCompleter?.complete(false);
        _refreshCompleter = null;
        await _handleSessionExpired();
      }
    }

    super.onError(err, handler);
  }

  /// Dispatches the token refresh request using a clean, isolated Dio instance
  Future<bool> _refreshTokenCall() async {
    try {
      final currentRefresh = refreshToken;
      if (currentRefresh == null || currentRefresh.isEmpty) return false;

      final hasInternet = await ConnectivityService().hasInternetConnection();
      if (!hasInternet) return false;

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Authorization': 'Basic ${ApiEndpoints.basicAuthToken}',
            'Content-Type': 'application/json',
            'Accept': '*/*',
          },
        ),
      );

      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': currentRefresh},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null && data['access_token'] != null) {
          final newAccess = data['access_token'] as String;
          final newRefresh = (data['refresh_token'] as String?) ?? currentRefresh;

          setTokens(access: newAccess, refresh: newRefresh);

          // Atomically persist the fresh tokens in local storage
          await CacheService().updateTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );

          debugPrint('[GSTSOF_DEBUG] -> Token refreshed & persisted successfully.');
          return true;
        }
      }
    } catch (e) {
      debugPrint('[GSTSOF_DEBUG] -> Token refresh network call failed: $e');
    }
    return false;
  }

  /// Completely clears cached and memory session data and redirects the user to the Login screen
  static Future<void> _handleSessionExpired() async {
    clearTokens();
    await CacheService().clearSession();
    debugPrint('[GSTSOF_DEBUG] -> Session expired. Redirecting to Login.');
    try {
      AppRouter.router.go(AppRouter.login);
    } catch (_) {}
  }
}
