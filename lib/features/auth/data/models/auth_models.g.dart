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

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String?,
  mobile: json['mobile'] as String?,
  profileId: json['profile_id'] as String?,
  companyName: json['company_name'] as String?,
  gstin: json['gstin'] as String?,
  pan: json['pan'] as String?,
  apiWalletBalance: json['api_wallet_balance'] as String?,
  supportCode: json['support_code'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'mobile': instance.mobile,
  'profile_id': instance.profileId,
  'company_name': instance.companyName,
  'gstin': instance.gstin,
  'pan': instance.pan,
  'api_wallet_balance': instance.apiWalletBalance,
  'support_code': instance.supportCode,
};

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  otpSessionToken: json['otp_session_token'] as String?,
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'user': instance.user,
  'otp_session_token': instance.otpSessionToken,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  status: json['status'] as String,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AuthData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
