class ApiEndpoints {
  static const String baseUrl = 'https://gstsof.com';
  static const String login = '/api/v1/auth/login';
  static const String refreshToken = '/api/v1/auth/token/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String sendOtp = '/api/v1/auth/otp/send';
  static const String verifyOtp = '/api/v1/auth/otp/verify';
  static const String me = '/api/v1/auth/me';

  // Exact Postman/Apidog generated Basic Auth token and credentials
  static const String basicAuthToken = 'MDFhMTRlM2MtY2Y2Mi03MjcxLWI2NWUtOWE4MjJhNDJiZDI3OnlNZTF0bjNtVDcxUFl4NGlSNUhZQWVZZDFMTWp1Y0hkMVZ0SXhycms=';
  static const String defaultClientId = '01a14e3c-cf62-7271-b65e-9a822a42bd27';
  static const String defaultClientSecret = 'yMe1tn3mT71PYx4iR5HYAeYd1LMju0Hd1VtIxrk';
}
