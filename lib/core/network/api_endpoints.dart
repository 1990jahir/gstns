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

  // Correct working Basic Auth token from register cURL specification
  static const String basicAuthToken = 'MDFhMTNhN2UtNjViNS03MWJlLWExNGYtZDNmOTk3OTY0MjAxOkM3TzliTXFlbWtab2t3RERGRzJpTng1UDNsVHBJOUJwUTVKVXpFTGM=';
  static const String defaultClientId = '01a13a7e-65b5-71be-a14f-d3f997964201';
  static const String defaultClientSecret = 'C7O9bMqemkZokwDDFG2iNx5P3lTpI9BpQ5JUzETLc';
}
