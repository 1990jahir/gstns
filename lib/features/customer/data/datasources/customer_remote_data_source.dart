import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

class CustomerRemoteDataSource {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> getCustomers({int page = 1, String? search}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.customers,
        queryParameters: {'page': page, if (search != null && search.isNotEmpty) 'search': search},
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.customers, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
