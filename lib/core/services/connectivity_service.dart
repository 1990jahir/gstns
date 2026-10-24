import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity Service checking real-time internet availability using connectivity_plus.
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (_) {
      // Default to true in case platform check throws on certain release configurations
      return true;
    }
  }
}
