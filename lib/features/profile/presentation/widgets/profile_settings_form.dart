import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'profile_dropdown_field.dart';

/// Clean decoupled Profile Settings Form widget.
class ProfileSettingsForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController dobController;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onUploadPhoto;
  final VoidCallback onChangeMobile;
  final bool isDark;

  const ProfileSettingsForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.mobileController,
    required this.dobController,
    required this.onSave,
    required this.onCancel,
    required this.onUploadPhoto,
    required this.onChangeMobile,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Upload Photo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringManager.profileInformationTitle,
                    style: getBoldStyle(
                      fontSize: FontManager.s18,
                      color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StringManager.updatePersonalDetails,
                    style: getRegularStyle(
                      fontSize: FontManager.s13,
                      color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onUploadPhoto,
                icon: const Icon(Icons.camera_alt_outlined, size: 16, color: ColorManager.primaryGreen),
                label: Text(StringManager.uploadPhoto, style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.primaryGreen)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryGreen.withValues(alpha: 0.12),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // User Card Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? ColorManager.darkSurface : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: ColorManager.primaryGreen,
                      child: Text('SB', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: ColorManager.primaryGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            StringManager.profileNameValue,
                            style: getBoldStyle(
                              fontSize: FontManager.s16,
                              color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              StringManager.adminBadge,
                              style: getBoldStyle(fontSize: FontManager.s10, color: ColorManager.primaryGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        StringManager.profileEmailValue,
                        style: getRegularStyle(fontSize: FontManager.s13, color: ColorManager.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        StringManager.profileContactValue,
                        style: getRegularStyle(fontSize: FontManager.s13, color: ColorManager.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form Fields Grid
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.firstNameLabel,
                  hintText: 'First Name',
                  controller: firstNameController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.lastNameLabel,
                  hintText: 'Last Name',
                  controller: lastNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.emailLabelProfile,
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringManager.mobileNumberLabel,
                      style: getMediumStyle(
                        fontSize: FontManager.s13,
                        color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: mobileController,
                            style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onChangeMobile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(StringManager.changeBtn, style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileDropdownField(
                  label: StringManager.genderLabel,
                  value: 'Male',
                  items: const ['Male', 'Female', 'Other'],
                  onChanged: (_) {},
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.dobLabel,
                  hintText: 'DD/MM/YYYY',
                  controller: dobController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileDropdownField(
                  label: StringManager.preferredLanguageLabel,
                  value: 'English',
                  items: const ['English', 'Hindi', 'Bengali', 'Tamil'],
                  onChanged: (_) {},
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProfileDropdownField(
                  label: StringManager.timeZoneLabel,
                  value: 'India Standard Time (IST) — UTC+05:30',
                  items: const ['India Standard Time (IST) — UTC+05:30', 'UTC', 'GMT'],
                  onChanged: (_) {},
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                  label: Text(StringManager.saveChangesBtn, style: getBoldStyle(fontSize: FontManager.s15, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close_rounded, size: 18, color: Colors.red),
                  label: Text(StringManager.cancelBtn, style: getBoldStyle(fontSize: FontManager.s15, color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.red.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
