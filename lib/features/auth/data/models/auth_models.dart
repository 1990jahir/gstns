import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class TokenRefreshRequest {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  TokenRefreshRequest({required this.refreshToken});

  factory TokenRefreshRequest.fromJson(Map<String, dynamic> json) => _$TokenRefreshRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TokenRefreshRequestToJson(this);
}

@JsonSerializable()
class OtpSendRequest {
  final String mobile;

  OtpSendRequest({required this.mobile});

  factory OtpSendRequest.fromJson(Map<String, dynamic> json) => _$OtpSendRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpSendRequestToJson(this);
}

@JsonSerializable()
class OtpVerifyRequest {
  @JsonKey(name: 'otp_session_token')
  final String otpSessionToken;
  final String otp;

  OtpVerifyRequest({required this.otpSessionToken, required this.otp});

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) => _$OtpVerifyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpVerifyRequestToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String? name;
  final String? mobile;
  @JsonKey(name: 'profile_id')
  final String? profileId;
  @JsonKey(name: 'company_name')
  final String? companyName;
  final String? gstin;
  final String? pan;
  @JsonKey(name: 'api_wallet_balance')
  final String? apiWalletBalance;
  @JsonKey(name: 'support_code')
  final String? supportCode;

  User({
    required this.id,
    required this.email,
    this.name,
    this.mobile,
    this.profileId,
    this.companyName,
    this.gstin,
    this.pan,
    this.apiWalletBalance,
    this.supportCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class AuthData {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final User? user;
  @JsonKey(name: 'otp_session_token')
  final String? otpSessionToken;

  AuthData({
    required this.accessToken,
    required this.refreshToken,
    this.user,
    this.otpSessionToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => _$AuthDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String status;
  final String? message;
  final AuthData? data;

  AuthResponse({required this.status, this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
