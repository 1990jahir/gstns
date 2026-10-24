import '../../../../core/network/api_exception.dart';
import '../../data/datasources/customer_remote_data_source.dart';

class CustomerRepository {
  final CustomerRemoteDataSource _remoteDataSource = CustomerRemoteDataSource();

  Future<Map<String, dynamic>> getCustomers({int page = 1, String? search}) async {
    try {
      return await _remoteDataSource.getCustomers(page: page, search: search);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.createCustomer(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
