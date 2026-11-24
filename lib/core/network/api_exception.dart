import 'package:dio/dio.dart';
import '../res/string_manager.dart';

/// Exception handler class converting Dio errors into clean readable messages.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.error,
  });

  factory ApiException.fromDioException(DioException dioException) {
    String message = StringManager.unexpectedError;
    int? statusCode = dioException.response?.statusCode;
    String? code;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = StringManager.connectionTimeout;
        break;
      case DioExceptionType.badResponse:
        try {
          final data = dioException.response?.data;
          if (data is Map) {
            if (data.containsKey('message')) {
              message = data['message'].toString();
            } else {
              message = '${dioException.response?.statusMessage ?? StringManager.serverError} (${dioException.response?.statusCode})';
            }
            if (data.containsKey('code')) {
              code = data['code'].toString();
            }
          } else {
            message = '${dioException.response?.statusMessage ?? StringManager.serverError} (${dioException.response?.statusCode})';
          }
        } catch (_) {
          message = StringManager.serverErrorOccurred;
        }
        break;
      case DioExceptionType.cancel:
        message = StringManager.requestCancelled;
        break;
      case DioExceptionType.connectionError:
        message = StringManager.noInternetConnection;
        break;
      case DioExceptionType.badCertificate:
        message = StringManager.securityCertificateError;
        break;
      case DioExceptionType.unknown:
      default:
        message = StringManager.networkConnectionFailed;
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      code: code,
      error: dioException.error,
    );
  }

  @override
  String toString() => message;
}
