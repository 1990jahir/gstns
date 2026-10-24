import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_footer.dart';
import '../../../../core/widgets/global_input_field.dart';
import '../../../../core/widgets/global_loader.dart';
import '../providers/auth_provider.dart';
import '../widgets/step_indicator.dart';
import 'register_header.dart';

/// Decoupled Business Information Step (Step 0) for Register Page with GSTIN verification and autofill.
class RegisterBusinessStep extends ConsumerStatefulWidget {
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
  ConsumerState<RegisterBusinessStep> createState() => _RegisterBusinessStepState();
}

class _RegisterBusinessStepState extends ConsumerState<RegisterBusinessStep> {
  Future<void> _verifyAndAutofillGstin() async {
    if (widget.gstinController.text.isEmpty) {
      context.showSnackBar(StringManager.pleaseEnterGstinToVerify, isError: true);
      return;
    }
    GlobalLoader.show(context, message: StringManager.verifyingGstin);
    try {
      final repository = ref.read(authRepositoryProvider);
      final res = await repository.verifyGstin(widget.gstinController.text.trim());
      if (!mounted) return;
      GlobalLoader.hide(context);

      if (res['status'] == 'success' && res['data'] != null) {
        final data = res['data'];
        setState(() {
          widget.companyController.text = data['company_name'] ?? data['name'] ?? '';
        });
        context.showSnackBar(StringManager.gstinVerifiedAutofilled);
      } else {
        final err = res['message'] ?? 'GSTIN verification failed';
        context.showSnackBar(err, isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      GlobalLoader.hide(context);
      context.showSnackBar(e.toString().replaceAll('ApiException: ', ''), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
                        color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: widget.isDark ? ColorManager.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.isDark ? ColorManager.darkBorder : const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: widget.accountType,
                          isExpanded: true,
                          dropdownColor: widget.isDark ? ColorManager.darkCard : Colors.white,
                          items: ['Registered', 'Unregistered', 'Composition']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type, style: getRegularStyle(fontSize: FontManager.s14, color: widget.isDark ? Colors.white : Colors.black87)),
                                  ))
                              .toList(),
                          onChanged: widget.onAccountTypeChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlobalInputField(
                  label: StringManager.gstin,
                  hintText: '19ABCDE...',
                  controller: widget.gstinController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _verifyAndAutofillGstin,
              icon: const Icon(Icons.verified_rounded, size: 16, color: Colors.white),
              label: Text(StringManager.verifyAndAutofillGstinBtn, style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GlobalInputField(
            label: StringManager.companyName,
            hintText: 'Company Name',
            controller: widget.companyController,
            validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GlobalInputField(
                  label: StringManager.firstName,
                  hintText: 'First Name',
                  controller: widget.firstNameController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlobalInputField(
                  label: StringManager.lastName,
                  hintText: 'Last Name',
                  controller: widget.lastNameController,
                  validator: (v) => v == null || v.isEmpty ? StringManager.fieldRequired : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: StringManager.continueBtn,
            icon: Icons.arrow_forward_rounded,
            onPressed: widget.onContinue,
          ),
          const SizedBox(height: 24),
          CustomFooter(
            text: StringManager.alreadyHaveAccount,
            actionText: StringManager.signInLink,
            onTap: widget.onSignInTap,
          ),
        ],
      ),
    );
  }
}
