import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'company_dropdown_field.dart';

/// Clean decoupled Company Settings Form widget matching web reference screenshot.
class CompanySettingsForm extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onUploadLogo;
  final bool isDark;

  const CompanySettingsForm({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.onUploadLogo,
    required this.isDark,
  });

  @override
  State<CompanySettingsForm> createState() => _CompanySettingsFormState();
}

class _CompanySettingsFormState extends State<CompanySettingsForm> {
  String _registrationType = 'Unregistered Business';
  String _typeOfOrg = 'Foreign Company';
  String _industriesType = 'Advertising & Media';
  String _businessType = 'Select Business Type';
  String _state = 'Please Select';

  final _panController = TextEditingController(text: 'CGHP0707E');
  final _companyController = TextEditingController(text: 'SB USER4');
  final _authPanController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _tanController = TextEditingController();
  final _cinController = TextEditingController();
  final _cinValidityController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _placeController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _rubberBoardReport = false;

  @override
  void dispose() {
    _panController.dispose();
    _companyController.dispose();
    _authPanController.dispose();
    _aadhaarController.dispose();
    _tanController.dispose();
    _cinController.dispose();
    _cinValidityController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _placeController.dispose();
    _cityController.dispose();
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
          // Header Row with Upload Logo (Wrapped in Expanded to prevent overflow)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringManager.companySettingsTitle,
                      style: getBoldStyle(
                        fontSize: FontManager.s18,
                        color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      StringManager.updateCompanyDetails,
                      style: getRegularStyle(
                        fontSize: FontManager.s13,
                        color: widget.isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onUploadLogo,
                    icon: const Icon(Icons.business_rounded, size: 16, color: ColorManager.primaryGreen),
                    label: Text(StringManager.uploadLogo, style: getBoldStyle(fontSize: FontManager.s12, color: ColorManager.primaryGreen)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryGreen.withValues(alpha: 0.12),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StringManager.recommendedLogoSize,
                    style: getRegularStyle(fontSize: FontManager.s10, color: ColorManager.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Business Information Section
          Text(
            StringManager.businessInformationTitle,
            style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.registrationTypeLabel,
                  value: _registrationType,
                  items: const ['Unregistered Business', 'Registered Business - Regular', 'Composition'],
                  onChanged: (val) => setState(() => _registrationType = val!),
                  isDark: widget.isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.panLabel,
                  hintText: 'CGHP0707E',
                  controller: _panController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: StringManager.companyName,
            hintText: 'Company Name',
            controller: _companyController,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.typeOfOrganizationLabel,
                  value: _typeOfOrg,
                  items: const ['Foreign Company', 'Private Limited', 'Partnership', 'Proprietorship'],
                  onChanged: (val) => setState(() => _typeOfOrg = val!),
                  isDark: widget.isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CompanyDropdownField(
                  label: StringManager.industriesTypeLabel,
                  value: _industriesType,
                  items: const ['Advertising & Media', 'Information Technology', 'Manufacturing', 'Retail'],
                  onChanged: (val) => setState(() => _industriesType = val!),
                  isDark: widget.isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CompanyDropdownField(
            label: StringManager.businessTypeLabel,
            value: _businessType,
            items: const ['Select Business Type', 'Service Provider', 'Manufacturer', 'Trader'],
            onChanged: (val) => setState(() => _businessType = val!),
            isDark: widget.isDark,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: StringManager.authorizedSignatoryPan,
            hintText: 'AAAAA9999A',
            controller: _authPanController,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.aadhaarNo,
                  hintText: 'Enter Aadhaar Number',
                  controller: _aadhaarController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.tanLabel,
                  hintText: 'ENTER TAN',
                  controller: _tanController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.cinLabel,
                  hintText: 'ENTER CIN',
                  controller: _cinController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.cinValidityLabel,
                  hintText: 'DD/MM/YYYY',
                  controller: _cinValidityController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Address Information Section
          Text(
            StringManager.addressInformationTitle,
            style: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.primaryGreen),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.addressLine1Label,
                  hintText: 'Address Line 1',
                  controller: _address1Controller,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.addressLine2Label,
                  hintText: 'Address Line 2',
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
                  hintText: 'Place',
                  controller: _placeController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: StringManager.cityLabelCompany,
                  hintText: 'City',
                  controller: _cityController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: StringManager.pincodeLabelCompany,
                  hintText: 'Pincode',
                  controller: _pincodeController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Rubber Board Report Query Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? ColorManager.darkSurface : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorManager.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringManager.rubberBoardQuery,
                        style: getBoldStyle(fontSize: FontManager.s13, color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        StringManager.rubberBoardSubtitle,
                        style: getRegularStyle(fontSize: FontManager.s11, color: ColorManager.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('No'),
                      selected: !_rubberBoardReport,
                      onSelected: (val) => setState(() => _rubberBoardReport = false),
                      selectedColor: Colors.red.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Yes'),
                      selected: _rubberBoardReport,
                      onSelected: (val) => setState(() => _rubberBoardReport = true),
                      selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: widget.onSave,
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
                  onPressed: widget.onCancel,
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
