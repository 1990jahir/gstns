class ApiEndpoints {
  static const String baseUrl = 'https://gstsof.com';
  static const String login = '/api/v1/auth/login';
  static const String refreshToken = '/api/v1/auth/token/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String sendOtp = '/api/v1/auth/otp/send';
  static const String verifyOtp = '/api/v1/auth/otp/verify';
  static const String me = '/api/v1/auth/me';

  // Registration & Challenge & GSTIN endpoints from API specification
  static const String register = '/api/v1/register';
  static const String challenge = '/api/v1/auth/challenge';
  static const String verifyGstin = '/api/v1/gstin/verify';

  // Feature endpoints
  static const String customers = '/api/v1/customers';
  static const String invoices = '/api/v1/invoices';
  static const String reportsProfitLoss = '/api/v1/reports/profit-loss';

  // Correct Basic Auth token from Postman / register cURL specification
  static const String basicAuthToken = 'MDFhMTRlM2MtY2Y2Mi03MjcxLWI2NWUtOWE4MjJhNDJiZDI3OnlNZTF0bjNtVDcxUFl4NGlSNUhZQWVZZDFMTWp1Y0hkMVZ0SXhycms=';
  static const String defaultClientId = '01a14e3c-cf62-7271-b65e-9a822a42bd27';
  static const String defaultClientSecret = 'yMe1tn3mT71PYx4iR5HYAeYd1LMju0Hd1VtIxrk';
}
