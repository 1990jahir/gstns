// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

TokenRefreshRequest _$TokenRefreshRequestFromJson(Map<String, dynamic> json) =>
    TokenRefreshRequest(refreshToken: json['refresh_token'] as String);

Map<String, dynamic> _$TokenRefreshRequestToJson(
  TokenRefreshRequest instance,
) => <String, dynamic>{'refresh_token': instance.refreshToken};

OtpSendRequest _$OtpSendRequestFromJson(Map<String, dynamic> json) =>
    OtpSendRequest(mobile: json['mobile'] as String);

Map<String, dynamic> _$OtpSendRequestToJson(OtpSendRequest instance) =>
    <String, dynamic>{'mobile': instance.mobile};

OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) =>
    OtpVerifyRequest(
      otpSessionToken: json['otp_session_token'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$OtpVerifyRequestToJson(OtpVerifyRequest instance) =>
    <String, dynamic>{
      'otp_session_token': instance.otpSessionToken,
      'otp': instance.otp,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  gstin: json['gstin'] as String?,
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gstin': instance.gstin,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  mobile: json['mobile'] as String?,
  company: json['company'] == null
      ? null
      : Company.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'mobile': instance.mobile,
  'company': instance.company,
};

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  tokenType: json['token_type'] as String,
  accessToken: json['access_token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  expiresAt: json['expires_at'] as String,
  refreshToken: json['refresh_token'] as String,
  refreshTokenExpiresIn: (json['refresh_token_expires_in'] as num).toInt(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'token_type': instance.tokenType,
  'access_token': instance.accessToken,
  'expires_in': instance.expiresIn,
  'expires_at': instance.expiresAt,
  'refresh_token': instance.refreshToken,
  'refresh_token_expires_in': instance.refreshTokenExpiresIn,
  'user': instance.user,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  status: json['status'] as String,
  statusCode: (json['status_code'] as num).toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AuthData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
