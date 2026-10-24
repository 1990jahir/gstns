import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_footer.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/step_indicator.dart';
import 'register_header.dart';

/// Decoupled Business Information Step (Step 0) for Register Page.
class RegisterBusinessStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController gstinController;
  final TextEditingController companyController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String accountType;
  final ValueChanged<String?> onAccountTypeChanged;
  final VoidCallback onContinue;
  final VoidCallback onSignInTap;
  final bool isDark;

  const RegisterBusinessStep({
    super.key,
    required this.formKey,
    required this.gstinController,
    required this.companyController,
    required this.firstNameController,
    required this.lastNameController,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.onContinue,
    required this.onSignInTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegisterHeader(),
          const SizedBox(height: 24),
          const StepIndicator(currentStep: 0),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringManager.accountType,
                      style: getMediumStyle(
                        fontSize: FontManager.s13,
                        color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isDark ? ColorManager.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? ColorManager.darkBorder : const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: accountType,
                          isExpanded: true,
                          dropdownColor: isDark ? ColorManager.darkCard : Colors.white,
                          items: ['Registered', 'Unregistered', 'Composition']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type, style: getRegularStyle(fontSize: FontManager.s14, color: isDark ? Colors.white : Colors.black87)),
                                  ))
                              .toList(),
                          onChanged: onAccountTypeChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.gstin,
                  hintText: '19ABCDE...',
                  controller: gstinController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: StringManager.companyName,
            hintText: 'Company Name',
            controller: companyController,
            validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.firstName,
                  hintText: 'First Name',
                  controller: firstNameController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.lastName,
                  hintText: 'Last Name',
                  controller: lastNameController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: StringManager.continueBtn,
            icon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
          const SizedBox(height: 24),
          CustomFooter(
            text: StringManager.alreadyHaveAccount,
            actionText: StringManager.signInLink,
            onTap: onSignInTap,
          ),
        ],
      ),
    );
  }
}
