import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Create Purchase Bill / Inward Invoice Page matching website fields.
class CreatePurchaseBillPage extends StatefulWidget {
  const CreatePurchaseBillPage({super.key});

  @override
  State<CreatePurchaseBillPage> createState() => _CreatePurchaseBillPageState();
}

class _CreatePurchaseBillPageState extends State<CreatePurchaseBillPage> {
  final _formKey = GlobalKey<FormState>();

  final _supplierBillNoController = TextEditingController();
  final _billDateController = TextEditingController(text: '24/10/2026');
  final _dueDateController = TextEditingController(text: '07/11/2026');
  final _itemDescriptionController = TextEditingController();
  final _taxableAmountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedVendor = 'TATA STEEL LIMITED';
  String _placeOfSupply = 'West Bengal (19)';
  String _taxRate = '18%';
  String _itcEligibility = 'Inputs (Raw Materials / Stock)';
  bool _reverseCharge = false;

  static const List<String> _vendors = [
    'TATA STEEL LIMITED',
    'ABB India Limited',
    'Schneider Electric India',
    'Siemens Healthcare Pvt Ltd',
  ];

  static const List<String> _states = [
    'West Bengal (19)',
    'Maharashtra (27)',
    'Delhi (07)',
    'Karnataka (29)',
    'Tamil Nadu (33)',
  ];

  static const List<String> _taxRates = ['0%', '5%', '12%', '18%', '28%'];

  static const List<String> _itcClassifications = [
    'Inputs (Raw Materials / Stock)',
    'Capital Goods (Machinery / Equipment)',
    'Input Services (Professional / Transport)',
    'Ineligible ITC (Section 17(5) Blocked Credit)',
  ];

  @override
  void dispose() {
    _supplierBillNoController.dispose();
    _billDateController.dispose();
    _dueDateController.dispose();
    _itemDescriptionController.dispose();
    _taxableAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Purchase Bill "${_supplierBillNoController.text}" recorded successfully!');
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
          StringManager.createPurchaseBill,
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
              StringManager.savePurchaseBill,
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
              // Vendor Selection
              Text(
                'Vendor / Supplier *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVendor,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _vendors.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedVendor = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Supplier Bill No. & Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _supplierBillNoController,
                      label: StringManager.supplierInvoiceNo,
                      hintText: 'e.g. TATA/2026/891',
                      prefixIcon: Icons.receipt_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _billDateController,
                      label: 'Bill Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Place of Supply & Due Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Place of Supply *',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _placeOfSupply,
                              isExpanded: true,
                              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _placeOfSupply = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _dueDateController,
                      label: 'Payment Due Date',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.event_available_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Line Item Description
              GlobalInputField(
                controller: _itemDescriptionController,
                label: 'Goods / Material Description *',
                hintText: 'e.g. Hot Rolled Steel Coils (Grade A)',
                prefixIcon: Icons.category_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Taxable Amount & GST Slab
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _taxableAmountController,
                      label: 'Taxable Amount (₹) *',
                      hintText: 'e.g. 185000',
                      prefixIcon: Icons.currency_rupee_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GST Tax Slab *',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _taxRate,
                              isExpanded: true,
                              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              items: _taxRates.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _taxRate = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ITC Classification
              Text(
                StringManager.itcClassification,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _itcEligibility,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _itcClassifications.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _itcEligibility = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Reverse Charge (RCM) Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reverse Charge Mechanism (RCM)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Tax payable by recipient under Sec 9(3) / 9(4)',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _reverseCharge,
                      activeTrackColor: ColorManager.primaryGreen,
                      onChanged: (val) => setState(() => _reverseCharge = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              GlobalInputField(
                controller: _notesController,
                label: 'Remarks / Payment Notes',
                hintText: 'Add vendor instructions or bank account details...',
                prefixIcon: Icons.edit_note_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

