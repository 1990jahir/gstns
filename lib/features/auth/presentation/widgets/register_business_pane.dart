import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/res/color_manager.dart';
import 'floating_label_input.dart';

class RegisterBusinessPane extends StatefulWidget {
  final TextEditingController gstinController;
  final TextEditingController companyController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String accountType; // 'Registered' or 'Unregistered'
  final ValueChanged<String> onAccountTypeChanged;
  final bool isGstinVerified;
  final bool isVerifyingGstin;
  final VoidCallback onVerifyGstin;
  final String? gstinErrorMessage;
  final bool isGstinMessageOk;
  final String? companyErrorMessage;
  final String? firstNameErrorMessage;
  final String? lastNameErrorMessage;

  const RegisterBusinessPane({
    super.key,
    required this.gstinController,
    required this.companyController,
    required this.firstNameController,
    required this.lastNameController,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.isGstinVerified,
    required this.isVerifyingGstin,
    required this.onVerifyGstin,
    required this.gstinErrorMessage,
    required this.isGstinMessageOk,
    required this.companyErrorMessage,
    required this.firstNameErrorMessage,
    required this.lastNameErrorMessage,
  });

  @override
  State<RegisterBusinessPane> createState() => _RegisterBusinessPaneState();
}

class _RegisterBusinessPaneState extends State<RegisterBusinessPane> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRegistered = widget.accountType == 'Registered';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Segmented Control (Registered vs Unregistered)
        Container(
          height: 44,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? ColorManager.authSurfaceDark : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onAccountTypeChanged('Registered'),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isRegistered ? ColorManager.primaryGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isRegistered
                          ? [
                              BoxShadow(
                                color: ColorManager.primaryGreen.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Registered',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isRegistered ? Colors.white : (isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onAccountTypeChanged('Unregistered'),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !isRegistered ? ColorManager.primaryGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !isRegistered
                          ? [
                              BoxShadow(
                                color: ColorManager.primaryGreen.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Unregistered',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: !isRegistered ? Colors.white : (isDark ? ColorManager.authMutedDark : ColorManager.authMutedLight),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // GSTIN Input Field (Only if Registered)
        if (isRegistered) ...[
          FloatingLabelInput(
            controller: widget.gstinController,
            label: 'GSTIN',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
              UpperCaseTextFormatter(),
            ],
            keyboardType: TextInputType.text,
            suffixWidth: 92,
            validationState: widget.gstinErrorMessage != null
                ? InputValidationState.error
                : (widget.isGstinVerified ? InputValidationState.valid : InputValidationState.none),
            messageText: widget.gstinErrorMessage,
            isMessageOk: widget.isGstinMessageOk,
            suffixWidget: SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: widget.isVerifyingGstin || widget.gstinController.text.trim().length < 15
                    ? null
                    : widget.onVerifyGstin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isGstinVerified ? ColorManager.primaryGreen : ColorManager.primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  disabledForegroundColor: isDark ? Colors.white38 : Colors.black38,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: widget.isVerifyingGstin
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        widget.isGstinVerified ? 'Verified ✓' : 'Verify',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Company Name
        FloatingLabelInput(
          controller: widget.companyController,
          label: 'Company Name',
          textCapitalization: TextCapitalization.words,
          validationState: widget.companyErrorMessage != null ? InputValidationState.error : InputValidationState.none,
          messageText: widget.companyErrorMessage,
        ),
        const SizedBox(height: 16),

        // First Name & Last Name in Row
        Row(
          children: [
            Expanded(
              child: FloatingLabelInput(
                controller: widget.firstNameController,
                label: 'First Name',
                textCapitalization: TextCapitalization.words,
                validationState: widget.firstNameErrorMessage != null ? InputValidationState.error : InputValidationState.none,
                messageText: widget.firstNameErrorMessage,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FloatingLabelInput(
                controller: widget.lastNameController,
                label: 'Last Name',
                textCapitalization: TextCapitalization.words,
                validationState: widget.lastNameErrorMessage != null ? InputValidationState.error : InputValidationState.none,
                messageText: widget.lastNameErrorMessage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
