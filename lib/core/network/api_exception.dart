import 'package:dio/dio.dart';
import '../res/string_manager.dart';

/// Exception handler class converting Dio errors into clean readable messages.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiException.fromDioException(DioException dioException) {
    String message = StringManager.unexpectedError;
    int? statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = StringManager.connectionTimeout;
        break;
      case DioExceptionType.badResponse:
        try {
          final data = dioException.response?.data;
          if (data is Map && data.containsKey('message')) {
            message = data['message'].toString();
          } else {
            message = '${StringManager.serverError} (${dioException.response?.statusCode})';
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
      error: dioException.error,
    );
  }

  @override
  String toString() => message;
}
