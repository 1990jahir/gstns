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
class Company {
  final int id;
  final String name;
  final String? gstin;

  Company({required this.id, required this.name, this.gstin});

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final Company? company;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class AuthData {
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'expires_at')
  final String expiresAt;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'refresh_token_expires_in')
  final int refreshTokenExpiresIn;
  final User? user;

  AuthData({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.expiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => _$AuthDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String status;
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String? message;
  final AuthData? data;

  AuthResponse({
    required this.status,
    required this.statusCode,
    this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
