import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Add Transporter Page for E-Way Bills & Dispatch.
class AddTransporterPage extends StatefulWidget {
  const AddTransporterPage({super.key});

  @override
  State<AddTransporterPage> createState() => _AddTransporterPageState();
}

class _AddTransporterPageState extends State<AddTransporterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _transporterIdController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _transporterIdController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleNoController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Transporter "${_nameController.text}" added successfully!');
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
          StringManager.addTransporter,
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
              StringManager.saveTransporter,
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
              // Transporter Name
              GlobalInputField(
                controller: _nameController,
                label: StringManager.transporterName,
                hintText: 'e.g. VRL Logistics Ltd',
                prefixIcon: Icons.local_shipping_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Transporter ID / GSTIN
              GlobalInputField(
                controller: _transporterIdController,
                label: StringManager.transporterId,
                hintText: '15-digit TRANSIN or GSTIN',
                prefixIcon: Icons.badge_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Vehicle Number
              GlobalInputField(
                controller: _vehicleNoController,
                label: StringManager.vehicleNumber,
                hintText: 'e.g. MH 12 AB 1234',
                prefixIcon: Icons.directions_car_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Person & Phone
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _contactPersonController,
                      label: 'Contact Person',
                      hintText: 'Driver / Manager',
                      prefixIcon: Icons.person_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hintText: '9876543210',
                      prefixIcon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              GlobalInputField(
                controller: _emailController,
                label: 'Official Email',
                hintText: 'dispatch@vrllogistics.com',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Address
              GlobalInputField(
                controller: _addressController,
                label: 'Depot / Office Address',
                hintText: 'Plot 45, Transport Nagar',
                prefixIcon: Icons.location_on_rounded,
              ),
              const SizedBox(height: 16),

              // City, State, Pincode
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _cityController,
                      label: 'City',
                      hintText: 'Pune',
                      prefixIcon: Icons.location_city_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _stateController,
                      label: 'State',
                      hintText: 'Maharashtra',
                      prefixIcon: Icons.map_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GlobalInputField(
                controller: _pincodeController,
                label: 'Pincode',
                hintText: '411018',
                prefixIcon: Icons.pin_drop_rounded,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

