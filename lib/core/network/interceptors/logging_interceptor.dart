import 'package:dio/dio.dart';
import '../../utils/debug_utils.dart';

/// Interceptor to log requests and responses in debug mode.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    DebugUtils.log('REQUEST [${options.method}] => PATH: ${options.path} | DATA: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DebugUtils.log('RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DebugUtils.logError('ERROR [${err.response?.statusCode}] => PATH: ${err.requestOptions.path} | MESSAGE: ${err.message}');
    super.onError(err, handler);
  }
}
