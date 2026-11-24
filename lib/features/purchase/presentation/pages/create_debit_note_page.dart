import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Create Debit Note / Purchase Return Page matching website fields.
class CreateDebitNotePage extends StatefulWidget {
  const CreateDebitNotePage({super.key});

  @override
  State<CreateDebitNotePage> createState() => _CreateDebitNotePageState();
}

class _CreateDebitNotePageState extends State<CreateDebitNotePage> {
  final _formKey = GlobalKey<FormState>();

  final _debitNoteNoController = TextEditingController(text: 'DN-2026-003');
  final _originalBillNoController = TextEditingController();
  final _originalDateController = TextEditingController(text: '12/10/2026');
  final _dnDateController = TextEditingController(text: '24/10/2026');
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedVendor = 'TATA STEEL LIMITED';
  String _reason = '01 - Purchase Return / Rejection';
  String _taxRate = '18%';
  bool _reverseItc = true;

  static const List<String> _vendors = [
    'TATA STEEL LIMITED',
    'ABB India Limited',
    'Schneider Electric India',
    'Siemens Healthcare Pvt Ltd',
  ];

  static const List<String> _reasons = [
    '01 - Purchase Return / Rejection',
    '02 - Rate Difference / Price Reduction',
    '03 - Short Supply / Damaged Material',
    '04 - Other Adjustment',
  ];

  static const List<String> _taxRates = ['0%', '5%', '12%', '18%', '28%'];

  @override
  void dispose() {
    _debitNoteNoController.dispose();
    _originalBillNoController.dispose();
    _originalDateController.dispose();
    _dnDateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Debit Note "${_debitNoteNoController.text}" issued successfully!');
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
          StringManager.createDebitNote,
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
              StringManager.saveDebitNote,
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

              // Debit Note Number & Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _debitNoteNoController,
                      label: 'Debit Note No. *',
                      hintText: 'DN-2026-003',
                      prefixIcon: Icons.tag_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _dnDateController,
                      label: 'Debit Note Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Original Bill Reference
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _originalBillNoController,
                      label: StringManager.originalPurchaseBillNo,
                      hintText: 'e.g. TATA/2026/891',
                      prefixIcon: Icons.receipt_long_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _originalDateController,
                      label: 'Original Bill Date',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.event_available_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reason
              Text(
                StringManager.reasonForDebitNote,
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
                    value: _reason,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _reason = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Debit Amount & GST Slab
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _amountController,
                      label: 'Debit Taxable Value (₹) *',
                      hintText: 'e.g. 18000',
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

              // Reversal of ITC Toggle
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
                          'Reverse Input Tax Credit (ITC)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Automatic ITC reversal in GSTR-3B Table 4(B)',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _reverseItc,
                      activeTrackColor: ColorManager.primaryGreen,
                      onChanged: (val) => setState(() => _reverseItc = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              GlobalInputField(
                controller: _notesController,
                label: 'Notes / Remarks',
                hintText: 'Enter vendor dispute notes or credit memo details...',
                prefixIcon: Icons.edit_note_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

