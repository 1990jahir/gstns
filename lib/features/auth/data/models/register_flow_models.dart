// Models for Registration OTP & Sign-up Flow per GSTSOF API Specification v1.1

/// Response from POST /api/v1/register/otp/send
class RegisterOtpSendData {
  final String otpSessionToken;
  final int expiresIn;
  final int resendIn;

  const RegisterOtpSendData({
    required this.otpSessionToken,
    required this.expiresIn,
    required this.resendIn,
  });

  factory RegisterOtpSendData.fromJson(Map<String, dynamic> json) {
    return RegisterOtpSendData(
      otpSessionToken: json['otp_session_token']?.toString() ?? '',
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 600,
      resendIn: (json['resend_in'] as num?)?.toInt() ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
    'otp_session_token': otpSessionToken,
    'expires_in': expiresIn,
    'resend_in': resendIn,
  };
}

/// Response from POST /api/v1/register/otp/verify
class RegisterOtpVerifyData {
  final String signupToken;
  final int expiresIn;
  final String mobile;

  const RegisterOtpVerifyData({
    required this.signupToken,
    required this.expiresIn,
    required this.mobile,
  });

  factory RegisterOtpVerifyData.fromJson(Map<String, dynamic> json) {
    return RegisterOtpVerifyData(
      signupToken: json['signup_token']?.toString() ?? '',
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 1800,
      mobile: json['mobile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'signup_token': signupToken,
    'expires_in': expiresIn,
    'mobile': mobile,
  };
}

/// Complete Registration Payload for POST /api/v1/register
class RegisterPayload {
  final String signupToken;
  final int userType; // 3 for Registered, 7 for Unregistered
  final String companyName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? referralCode;
  final String? gstin;
  final String? panNo;

  const RegisterPayload({
    required this.signupToken,
    required this.userType,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.referralCode,
    this.gstin,
    this.panNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'signup_token': signupToken,
      'user_type': userType,
      if (userType == 3 && gstin != null && gstin!.isNotEmpty) 'gstin': gstin!.toUpperCase(),
      if (userType == 7 && panNo != null && panNo!.isNotEmpty) 'pan_no': panNo!.toUpperCase(),
      'company_name': companyName.trim(),
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'password_confirmation': passwordConfirmation,
      'referral_code': (referralCode ?? '').trim().toUpperCase(),
    };
  }
}

/// Response from POST /api/v1/register
class RegisterAccountResponse {
  final String status;
  final int statusCode;
  final String message;
  final bool loginRequired;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final Map<String, dynamic>? userData;

  const RegisterAccountResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.loginRequired,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.userData,
  });

  factory RegisterAccountResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return RegisterAccountResponse(
      status: json['status']?.toString() ?? 'success',
      statusCode: (json['status_code'] as num?)?.toInt() ?? 201,
      message: json['message']?.toString() ?? '',
      loginRequired: data['login_required'] == true,
      accessToken: data['access_token']?.toString(),
      refreshToken: data['refresh_token']?.toString(),
      expiresIn: (data['expires_in'] as num?)?.toInt(),
      userData: data['user'] as Map<String, dynamic>?,
    );
  }
}

