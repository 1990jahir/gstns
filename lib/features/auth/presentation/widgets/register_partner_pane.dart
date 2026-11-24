import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Professional Form Pane for Partner (CA, Tax Practitioner, Advocate) Registration.
class RegisterPartnerPane extends StatelessWidget {
  final TextEditingController membershipController;
  final TextEditingController firmNameController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String selectedProfession;
  final ValueChanged<String> onProfessionChanged;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final String? professionError;
  final String? membershipError;
  final String? firmNameError;
  final String? cityError;
  final String? stateError;
  final String? fullNameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  const RegisterPartnerPane({
    super.key,
    required this.membershipController,
    required this.firmNameController,
    required this.cityController,
    required this.stateController,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedProfession,
    required this.onProfessionChanged,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    this.professionError,
    this.membershipError,
    this.firmNameError,
    this.cityError,
    this.stateError,
    this.fullNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
  });

  static const List<String> professions = [
    StringManager.charteredAccountant,
    StringManager.taxPractitioner,
    StringManager.advocate,
    StringManager.accountingFirm,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Professional Header Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? ColorManager.primaryGreen.withValues(alpha: 0.12)
                : const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.primaryGreen.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorManager.primaryGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFF10B981),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      StringManager.partnerRegisterTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      StringManager.partnerRegisterSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Profession Selector
        Text(
          StringManager.selectProfession,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF374151),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: professions.map((p) {
            final isSelected = selectedProfession == p;
            return ChoiceChip(
              label: Text(p),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onProfessionChanged(p);
              },
              selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.18),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? ColorManager.primaryGreen
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? ColorManager.primaryGreen
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563)),
                fontFamily: 'Inter',
              ),
            );
          }).toList(),
        ),
        if (professionError != null) ...[
          const SizedBox(height: 4),
          Text(
            professionError!,
            style: const TextStyle(fontSize: 11, color: Colors.redAccent),
          ),
        ],
        const SizedBox(height: 16),

        // Membership / COP Number
        GlobalInputField(
          label: StringManager.membershipCopNumber,
          hintText: StringManager.membershipCopHint,
          prefixIcon: Icons.badge_outlined,
          controller: membershipController,
          validator: (v) => membershipError,
        ),
        const SizedBox(height: 16),

        // Firm / Practice Name
        GlobalInputField(
          label: StringManager.firmName,
          hintText: StringManager.firmNameHint,
          prefixIcon: Icons.apartment_rounded,
          controller: firmNameController,
          validator: (v) => firmNameError,
        ),
        const SizedBox(height: 16),

        // City & State Row
        Row(
          children: [
            Expanded(
              child: GlobalInputField(
                label: StringManager.city,
                hintText: StringManager.cityHint,
                prefixIcon: Icons.location_city_rounded,
                controller: cityController,
                validator: (v) => cityError,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlobalInputField(
                label: StringManager.state,
                hintText: StringManager.stateHint,
                prefixIcon: Icons.map_rounded,
                controller: stateController,
                validator: (v) => stateError,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Partner Full Name
        GlobalInputField(
          label: StringManager.partnerFullName,
          hintText: StringManager.partnerFullNameHint,
          prefixIcon: Icons.person_outline_rounded,
          controller: fullNameController,
          validator: (v) => fullNameError,
        ),
        const SizedBox(height: 16),

        // Official Email
        GlobalInputField(
          label: StringManager.partnerEmail,
          hintText: StringManager.partnerEmailHint,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          validator: (v) => emailError,
        ),
        const SizedBox(height: 16),

        // WhatsApp Phone
        GlobalInputField(
          label: StringManager.partnerPhone,
          hintText: StringManager.partnerPhoneHint,
          prefixIcon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          controller: phoneController,
          validator: (v) => phoneError,
        ),
        const SizedBox(height: 16),

        // Password
        GlobalInputField(
          label: StringManager.passwordLabel,
          hintText: StringManager.passwordHint,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: obscurePassword,
          controller: passwordController,
          validator: (v) => passwordError,
          suffixWidget: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF9CA3AF),
              size: 20,
            ),
            onPressed: onTogglePassword,
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password
        GlobalInputField(
          label: StringManager.confirmPassword,
          hintText: StringManager.passwordHint,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: obscureConfirmPassword,
          controller: confirmPasswordController,
          validator: (v) => confirmPasswordError,
          suffixWidget: IconButton(
            icon: Icon(
              obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF9CA3AF),
              size: 20,
            ),
            onPressed: onToggleConfirmPassword,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

