import 'package:shared_preferences/shared_preferences.dart';

/// Singleton Cache Service using SharedPreferences for local caching of tokens and user session data.
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;

  SharedPreferences? _prefs;

  CacheService._internal();

  /// Initializes SharedPreferences instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _ensurePrefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
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
    final prefs = await _ensurePrefs;
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  String? getAccessToken() => _prefs?.getString(_keyAccessToken);

  /// Atomically updates stored access and refresh tokens after successful token refresh.
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await _ensurePrefs;
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
  }
  String? getRefreshToken() => _prefs?.getString(_keyRefreshToken);
  String? getUserEmail() => _prefs?.getString(_keyUserEmail);
  bool isLoggedIn() => _prefs?.getBool(_keyIsLoggedIn) ?? false;

  /// Clears stored session data upon logout.
  Future<void> clearSession() async {
    final prefs = await _ensurePrefs;
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserEmail);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
