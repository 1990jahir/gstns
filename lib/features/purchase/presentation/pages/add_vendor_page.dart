import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Add Vendor / Supplier Page with GSTIN auto-fill.
class AddVendorPage extends StatefulWidget {
  const AddVendorPage({super.key});

  @override
  State<AddVendorPage> createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final _formKey = GlobalKey<FormState>();

  final _gstinController = TextEditingController();
  final _vendorNameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _panController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();

  bool _isLookingUpGstin = false;

  @override
  void dispose() {
    _gstinController.dispose();
    _vendorNameController.dispose();
    _tradeNameController.dispose();
    _panController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _onVerifyGstin() {
    final gstin = _gstinController.text.trim().toUpperCase();
    if (gstin.length != 15) {
      context.showSnackBar('Please enter a 15-character GSTIN', isError: true);
      return;
    }

    setState(() => _isLookingUpGstin = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isLookingUpGstin = false;
        _vendorNameController.text = 'TATA STEEL LIMITED';
        _tradeNameController.text = 'Tata Steel Downstream Products';
        _panController.text = gstin.substring(2, 12);
        _cityController.text = 'Mumbai';
        _stateController.text = 'Maharashtra';
      });
      context.showSnackBar('Vendor details autofilled from GST Portal!');
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Vendor "${_vendorNameController.text}" added successfully!');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.addVendor,
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Save Vendor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Inter'),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // GSTIN & Legal Identity Card
              _buildCard(
                title: 'GST & Legal Identity',
                isDark: isDark,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'Supplier GSTIN',
                          hintText: 'e.g. 27AAACT2727Q1ZW',
                          prefixIcon: Icons.badge_outlined,
                          controller: _gstinController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLookingUpGstin ? null : _onVerifyGstin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            child: _isLookingUpGstin
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Autofill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GlobalInputField(
                    label: 'Vendor / Company Name *',
                    hintText: 'e.g. Tata Steel Limited',
                    prefixIcon: Icons.apartment_rounded,
                    controller: _vendorNameController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Company name required' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'Trade Name',
                          hintText: 'e.g. Tata Steel',
                          prefixIcon: Icons.storefront_rounded,
                          controller: _tradeNameController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: 'PAN Number',
                          hintText: 'e.g. AAACT2727Q',
                          prefixIcon: Icons.credit_card_rounded,
                          controller: _panController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contact Details Card
              _buildCard(
                title: 'Contact Details',
                isDark: isDark,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'Phone / Mobile *',
                          hintText: '9820012345',
                          prefixIcon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Phone required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: 'Official Email',
                          hintText: 'supplies@tatasteel.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GlobalInputField(
                    label: 'Billing Address',
                    hintText: 'Factory / Office Street Address',
                    prefixIcon: Icons.location_on_outlined,
                    controller: _addressController,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'City',
                          hintText: 'e.g. Mumbai',
                          prefixIcon: Icons.location_city_rounded,
                          controller: _cityController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: 'State',
                          hintText: 'e.g. Maharashtra',
                          prefixIcon: Icons.map_rounded,
                          controller: _stateController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bank Accounts for Payments
              _buildCard(
                title: 'Settlement Bank Account',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: 'Bank Account Number',
                    hintText: 'e.g. 50200012345678',
                    prefixIcon: Icons.account_balance_outlined,
                    controller: _bankAccountController,
                  ),
                  const SizedBox(height: 14),
                  GlobalInputField(
                    label: 'IFSC Code',
                    hintText: 'e.g. HDFC0001234',
                    prefixIcon: Icons.qr_code_rounded,
                    controller: _ifscController,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

