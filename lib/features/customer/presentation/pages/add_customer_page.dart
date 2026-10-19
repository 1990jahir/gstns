import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/global_loader.dart';

/// Modern Add Customer Page featuring organized professional card sections and GSTIN auto-fetch.
class AddCustomerPage extends ConsumerStatefulWidget {
  const AddCustomerPage({super.key});

  @override
  ConsumerState<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends ConsumerState<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final _gstinController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _placeController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _cinController = TextEditingController();
  final _openingBalanceController = TextEditingController(text: '0.00');

  String _gstTreatment = 'Registered Business - Regular';
  String _customerType = 'Business';
  String _title = 'Mr.';
  String _state = 'West Bengal';
  String _paymentTerms = 'Due on receipt';
  String _openingBalanceType = 'Dr';
  bool _tdsApplicable = false;

  @override
  void dispose() {
    _gstinController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _placeController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _aadhaarController.dispose();
    _cinController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  void _onFetchGstin() {
    if (_gstinController.text.isEmpty) {
      context.showSnackBar('Please enter GSTIN to fetch details', isError: true);
      return;
    }
    GlobalLoader.show(context, message: 'Fetching GSTIN details...');
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      GlobalLoader.hide(context);
      setState(() {
        _companyController.text = 'GE T&D INDIA LIMITED';
        _address1Controller.text = 'Plot No. 12, Sector V, Salt Lake';
        _cityController.text = 'Kolkata';
        _state = 'West Bengal';
        _pincodeController.text = '700091';
      });
      context.showSnackBar('GSTIN details fetched successfully!');
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      GlobalLoader.show(context, message: 'Saving customer...');
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        GlobalLoader.hide(context);
        context.showSnackBar('Customer saved successfully!');
        context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Add Customer',
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Section 1: GST & Business Info
              _buildSectionCard(
                title: 'GST & Business Treatment',
                isDark: isDark,
                children: [
                  _buildDropdownField('GST Treatment *', _gstTreatment, ['Registered Business - Regular', 'Registered Business - Composition', 'Unregistered Business', 'Consumer'], (val) => setState(() => _gstTreatment = val!)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          label: 'GSTIN/UIN *',
                          hintText: '22AAAAA0000A1Z5',
                          controller: _gstinController,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: ElevatedButton.icon(
                          onPressed: _onFetchGstin,
                          icon: const Icon(Icons.sync_rounded, size: 16, color: Colors.white),
                          label: Text('Fetch GSTIN', style: getBoldStyle(fontSize: FontManager.s12, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField('Customer Type *', _customerType, ['Business', 'Individual'], (val) => setState(() => _customerType = val!)),
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Personal & Company Name
              _buildSectionCard(
                title: 'Identity & Names',
                isDark: isDark,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: _buildDropdownField('Title', _title, ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'M/s'], (val) => setState(() => _title = val!)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'First Name *',
                          hintText: 'First Name',
                          controller: _firstNameController,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Last Name *',
                          hintText: 'Last Name',
                          controller: _lastNameController,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Company Name *',
                          hintText: 'Company Name',
                          controller: _companyController,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Display Name',
                    hintText: 'Display Name on Invoices',
                    controller: _displayNameController,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Contact Info
              _buildSectionCard(
                title: 'Contact Details',
                isDark: isDark,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Email Address',
                          hintText: 'client@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Mobile No.',
                          hintText: '9876543210',
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 4: Address
              _buildSectionCard(
                title: 'Billing Address',
                isDark: isDark,
                children: [
                  CustomTextField(
                    label: 'Address Line 1 *',
                    hintText: 'Street address, building, etc.',
                    controller: _address1Controller,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Address Line 2 (Optional)',
                    hintText: 'Apartment, suite, unit, etc.',
                    controller: _address2Controller,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Place *',
                          hintText: 'Place',
                          controller: _placeController,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'City',
                          hintText: 'City',
                          controller: _cityController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField('State *', _state, ['West Bengal', 'Delhi', 'Maharashtra', 'Karnataka', 'Tamil Nadu', 'Uttar Pradesh'], (val) => setState(() => _state = val!)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Pincode *',
                          hintText: '700001',
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 5: Financials & Opening Balance
              _buildSectionCard(
                title: 'Financials & Opening Balance',
                isDark: isDark,
                children: [
                  _buildDropdownField('Payment Terms', _paymentTerms, ['Due on receipt', 'Net 15', 'Net 30', 'Net 45', 'Net 60'], (val) => setState(() => _paymentTerms = val!)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Opening Balance *',
                          hintText: '0.00',
                          controller: _openingBalanceController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: _buildDropdownField('Type *', _openingBalanceType, ['Dr', 'Cr'], (val) => setState(() => _openingBalanceType = val!)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('TDS Applicable:', style: getMediumStyle(fontSize: FontManager.s14, color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)),
                      const SizedBox(width: 16),
                      ChoiceChip(
                        label: const Text('Yes'),
                        selected: _tdsApplicable,
                        onSelected: (val) => setState(() => _tdsApplicable = true),
                        selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('No'),
                        selected: !_tdsApplicable,
                        onSelected: (val) => setState(() => _tdsApplicable = false),
                        selectedColor: ColorManager.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Close', style: getBoldStyle(fontSize: FontManager.s15, color: Colors.red.shade600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Save Customer',
                      icon: Icons.save_rounded,
                      onPressed: _onSave,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required bool isDark, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontSize: FontManager.s16,
              color: ColorManager.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              value: value,
              isExpanded: true,
              dropdownColor: isDark ? ColorManager.darkCard : Colors.white,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: getRegularStyle(
                            fontSize: FontManager.s14,
                            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
