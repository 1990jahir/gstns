import '../res/string_manager.dart';

/// Utility class providing form field validation methods.
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return StringManager.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return StringManager.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringManager.passwordRequired;
    }
    if (value.length < 6) {
      return StringManager.passwordTooShort;
    }
    return null;
  }

  static String? validateGstin(String? value) {
    if (value == null || value.isEmpty) {
      return StringManager.gstinRequired;
    }
    if (value.length != 15) {
      return StringManager.gstinLengthError;
    }
    final gstinRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (!gstinRegex.hasMatch(value.toUpperCase())) {
      return StringManager.gstinFormatError;
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return StringManager.mobileRequired;
    }
    final mobileRegex = RegExp(r'^[6-9][0-9]{9}$');
    if (!mobileRegex.hasMatch(value)) {
      return StringManager.enterValidPhone;
    }
    return null;
  }
}
