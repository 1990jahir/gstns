import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Create Delivery Challan Page (Rule 55 CGST Rules) matching website fields.
class CreateDeliveryChallanPage extends StatefulWidget {
  const CreateDeliveryChallanPage({super.key});

  @override
  State<CreateDeliveryChallanPage> createState() =>
      _CreateDeliveryChallanPageState();
}

class _CreateDeliveryChallanPageState extends State<CreateDeliveryChallanPage> {
  final _formKey = GlobalKey<FormState>();

  final _challanNoController = TextEditingController(text: 'DC-2026-003');
  final _challanDateController = TextEditingController(text: '24/10/2026');
  final _receiverNameController = TextEditingController();
  final _receiverGstinController = TextEditingController();
  final _dispatchAddressController = TextEditingController(
    text: 'Plot 12, Sector V, Salt Lake, Kolkata',
  );
  final _deliveryAddressController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _transporterController = TextEditingController();
  final _goodsDescriptionController = TextEditingController();
  final _approxValueController = TextEditingController();
  final _notesController = TextEditingController();

  String _challanPurpose = 'Job Work / Processing';
  bool _eWayBillRequired = false;

  static const List<String> _purposes = [
    'Job Work / Processing',
    'Supply on Approval',
    'Exhibition or Demonstration',
    'Transport for Own Use',
    'Line Sale',
    'Others',
  ];

  @override
  void dispose() {
    _challanNoController.dispose();
    _challanDateController.dispose();
    _receiverNameController.dispose();
    _receiverGstinController.dispose();
    _dispatchAddressController.dispose();
    _deliveryAddressController.dispose();
    _vehicleNoController.dispose();
    _transporterController.dispose();
    _goodsDescriptionController.dispose();
    _approxValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar(
        'Delivery Challan "${_challanNoController.text}" generated successfully!',
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.createDeliveryChallan,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark
                ? ColorManager.darkTextPrimary
                : ColorManager.lightTextPrimary,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              StringManager.saveDeliveryChallan,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
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
              // Challan Number & Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _challanNoController,
                      label: 'Challan Number *',
                      hintText: 'DC-2026-003',
                      prefixIcon: Icons.tag_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return StringManager.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _challanDateController,
                      label: 'Challan Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Purpose of Transportation
              Text(
                StringManager.challanPurpose,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _challanPurpose,
                    isExpanded: true,
                    dropdownColor: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _purposes
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _challanPurpose = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Receiver Name & GSTIN
              GlobalInputField(
                controller: _receiverNameController,
                label: 'Consignee / Receiver Name *',
                hintText: 'e.g. Precision Machining Works',
                prefixIcon: Icons.person_pin_circle_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return StringManager.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              GlobalInputField(
                controller: _receiverGstinController,
                label: 'Receiver GSTIN (Optional)',
                hintText: '15-digit GSTIN if registered',
                prefixIcon: Icons.badge_rounded,
              ),
              const SizedBox(height: 16),

              // Delivery Address
              GlobalInputField(
                controller: _deliveryAddressController,
                label: 'Delivery / Destination Address *',
                hintText: 'Industrial Area, Phase 2, Pune',
                prefixIcon: Icons.location_on_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return StringManager.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Vehicle & Transporter
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _vehicleNoController,
                      label: 'Vehicle Number *',
                      hintText: 'MH 12 AB 1234',
                      prefixIcon: Icons.directions_car_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return StringManager.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _transporterController,
                      label: 'Transporter Name',
                      hintText: 'VRL Logistics Ltd',
                      prefixIcon: Icons.local_shipping_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Goods Description & Value
              GlobalInputField(
                controller: _goodsDescriptionController,
                label: 'Description of Goods & Quantity *',
                hintText: 'e.g. 500 Pcs Steel Rods for Job Work',
                prefixIcon: Icons.inventory_2_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return StringManager.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              GlobalInputField(
                controller: _approxValueController,
                label: 'Approximate Value of Goods (₹) *',
                hintText: 'e.g. 85000',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return StringManager.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-Way Bill Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate E-Way Bill',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Required when consignment value exceeds ₹ 50,000',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _eWayBillRequired,
                      activeTrackColor: ColorManager.primaryGreen,
                      onChanged: (val) =>
                          setState(() => _eWayBillRequired = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              GlobalInputField(
                controller: _notesController,
                label: 'Terms & Conditions / Special Instructions',
                hintText: 'Return within 180 days after processing...',
                prefixIcon: Icons.edit_note_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
