import 'package:shared_preferences/shared_preferences.dart';

/// Singleton Cache Service using SharedPreferences for local caching of tokens and user session data.
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;

  late SharedPreferences _prefs;

  CacheService._internal();

  /// Initializes SharedPreferences instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Storage Keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Saves authentication session details locally.
  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required String email,
  }) async {
    await _prefs.setString(_keyAccessToken, accessToken);
    await _prefs.setString(_keyRefreshToken, refreshToken);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  String? getAccessToken() => _prefs.getString(_keyAccessToken);
  String? getRefreshToken() => _prefs.getString(_keyRefreshToken);
  String? getUserEmail() => _prefs.getString(_keyUserEmail);
  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  /// Clears stored session data upon logout.
  Future<void> clearSession() async {
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyUserEmail);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }
}
