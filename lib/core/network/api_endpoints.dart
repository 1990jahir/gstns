class ApiEndpoints {
  static const String baseUrl = 'https://api.gstsof.com';
  static const String login = '/api/v1/auth/login';
  static const String refreshToken = '/api/v1/auth/token/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String sendOtp = '/api/v1/auth/otp/send';
  static const String verifyOtp = '/api/v1/auth/otp/verify';
  static const String me = '/api/v1/auth/me';

  // Client credentials for Basic Auth (from Postman collection)
  static const String defaultClientId = 'client_id';
  static const String defaultClientSecret = 'client_secret';
}
