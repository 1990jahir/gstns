import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsState {
  final int selectedCategoryIndex;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String gender;
  final String dob;
  final String language;
  final String timeZone;
  final bool isLoading;

  ProfileSettingsState({
    this.selectedCategoryIndex = 0,
    this.firstName = 'SB',
    this.lastName = 'USER4',
    this.email = 'sbuser4@gstsof.com',
    this.mobile = '9477317208',
    this.gender = 'Male',
    this.dob = '',
    this.language = 'English',
    this.timeZone = 'India Standard Time (IST) — UTC+05:30',
    this.isLoading = false,
  });

  ProfileSettingsState copyWith({
    int? selectedCategoryIndex,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? gender,
    String? dob,
    String? language,
    String? timeZone,
    bool? isLoading,
  }) {
    return ProfileSettingsState(
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  ProfileSettingsNotifier() : super(ProfileSettingsState());

  void setCategoryIndex(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }

  void updateField({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? gender,
    String? dob,
    String? language,
    String? timeZone,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobile: mobile,
      gender: gender,
      dob: dob,
      language: language,
      timeZone: timeZone,
    );
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final profileSettingsNotifierProvider = StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>((ref) {
  return ProfileSettingsNotifier();
});
