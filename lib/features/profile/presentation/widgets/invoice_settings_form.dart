import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'company_dropdown_field.dart';

/// Clean decoupled Invoice Settings Form widget with iOS-style switches (CupertinoSwitch) matching web reference screenshot.
class InvoiceSettingsForm extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onPreview;
  final bool isDark;

  const InvoiceSettingsForm({
    super.key,
    required this.onSave,
    required this.onPreview,
    required this.isDark,
  });

  @override
  State<InvoiceSettingsForm> createState() => _InvoiceSettingsFormState();
}

class _InvoiceSettingsFormState extends State<InvoiceSettingsForm> {
  final _companyController = TextEditingController(text: 'SB USER4');
  final _emailController = TextEditingController(text: 'sbuser4@gstsof.com');
  final _phoneController = TextEditingController(text: '9477317208');
  final _whatsappController = TextEditingController(text: '9477317208');
  final _gstinController = TextEditingController(text: '16ALNPO9133H1ZI');
  final _panController = TextEditingController(text: 'ALNPO9133H');
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _placeController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _state = 'Please Select';
  String _primaryColor = '#16a34a';
  String _fontFamily = 'Inter';
  String _watermark = 'None';
  double _watermarkOpacity = 20.0;

  bool _showCompanyLogo = true;
  bool _showBankDetails = true;
  bool _showEmail = true;
  bool _showPhone = true;
  bool _showGstin = true;
  bool _showPan = true;

  @override
  void dispose() {
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _placeController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: widget.isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Preview Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringManager.invoiceSettingsTitle,
                    style: getBoldStyle(
                      fontSize: FontManager.s18,
                      color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StringManager.manageInvoiceLooks,
                    style: getRegularStyle(
                      fontSize: FontManager.s13,
                      color: widget.isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: widget.onPreview,
                icon: const Icon(Icons.preview_rounded, size: 16, color: Colors.white),
                label: Text(StringManager.previewInvoiceBtn, style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryGreen,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Business Information (Displayed on Invoice)
          Text(
            StringManager.businessInfoDisplayed,
            style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.companyName,
                  hintText: 'Company Name',
                  controller: _companyController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.emailLabel,
                  hintText: 'Email',
                  controller: _emailController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.phoneNumber,
                  hintText: 'Phone Number',
                  controller: _phoneController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'WhatsApp Number',
                  hintText: 'WhatsApp',
                  controller: _whatsappController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.gstin,
                  hintText: 'GSTIN',
                  controller: _gstinController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.panLabel,
                  hintText: 'PAN',
                  controller: _panController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.address1Label,
                  hintText: 'Address 1',
                  controller: _address1Controller,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.address2Label,
                  hintText: 'Address 2',
                  controller: _address2Controller,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.stateLabelCompany,
                  value: _state,
                  items: const ['Please Select', 'West Bengal', 'Delhi', 'Maharashtra', 'Karnataka'],
                  onChanged: (val) => setState(() => _state = val!),
                  isDark: widget.isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.placeLabelCompany,
                  hintText: 'Place / City',
                  controller: _placeController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: StringManager.pincodeLabelCompany,
            hintText: 'Pincode',
            controller: _pincodeController,
          ),
          const SizedBox(height: 32),

          // Invoice Appearance Section
          Text(
            StringManager.invoiceAppearanceTitle,
            style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.primaryColorLabel,
                  value: _primaryColor,
                  items: const ['#16a34a', '#0284c7', '#7c3aed', '#db2777'],
                  onChanged: (val) => setState(() => _primaryColor = val!),
                  isDark: widget.isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.fontFamilyLabel,
                  value: _fontFamily,
                  items: const ['Inter', 'Roboto', 'Poppins', 'Lato'],
                  onChanged: (val) => setState(() => _fontFamily = val!),
                  isDark: widget.isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildIosSwitchRow(StringManager.showCompanyLogoLabel, _showCompanyLogo, (val) => setState(() => _showCompanyLogo = val), widget.isDark),
          const SizedBox(height: 16),
          CompanyDropdownField(
            label: StringManager.watermarkOnInvoiceLabel,
            value: _watermark,
            items: const ['None', 'Confidential', 'Draft', 'Paid'],
            onChanged: (val) => setState(() => _watermark = val!),
            isDark: widget.isDark,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${StringManager.watermarkOpacityLabel}: ${_watermarkOpacity.toInt()}%', style: getMediumStyle(fontSize: FontManager.s13, color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
              Slider(
                value: _watermarkOpacity,
                min: 5.0,
                max: 100.0,
                activeColor: ColorManager.primaryGreen,
                onChanged: (val) => setState(() => _watermarkOpacity = val),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildIosSwitchRow(StringManager.showBankDetailsInvoiceLabel, _showBankDetails, (val) => setState(() => _showBankDetails = val), widget.isDark),
          const SizedBox(height: 32),

          // Additional Information (Show on Invoice)
          Text(
            StringManager.additionalInfoTitle,
            style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildCheckboxOption(StringManager.showEmailLabel, _showEmail, (val) => setState(() => _showEmail = val!)),
              _buildCheckboxOption(StringManager.showPhoneNumberLabel, _showPhone, (val) => setState(() => _showPhone = val!)),
              _buildCheckboxOption(StringManager.showGstinLabel, _showGstin, (val) => setState(() => _showGstin = val!)),
              _buildCheckboxOption(StringManager.showPanLabel, _showPan, (val) => setState(() => _showPan = val!)),
              _buildCheckboxOption(StringManager.showBankDetailsLabel, _showBankDetails, (val) => setState(() => _showBankDetails = val!)),
            ],
          ),
          const SizedBox(height: 36),

          // Save Button
          CustomButton(
            text: StringManager.saveInvoiceSettingsBtn,
            icon: Icons.save_rounded,
            onPressed: widget.onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildIosSwitchRow(String label, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontSize: FontManager.s14,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeTrackColor: ColorManager.primaryGreen,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCheckboxOption(String label, bool value, ValueChanged<bool?> onChanged) {
    final isDark = widget.isDark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          activeColor: ColorManager.primaryGreen,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: getRegularStyle(
            fontSize: FontManager.s13,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
