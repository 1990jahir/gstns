import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Create Credit Note / Sales Return Page matching website fields.
class CreateCreditNotePage extends StatefulWidget {
  const CreateCreditNotePage({super.key});

  @override
  State<CreateCreditNotePage> createState() => _CreateCreditNotePageState();
}

class _CreateCreditNotePageState extends State<CreateCreditNotePage> {
  final _formKey = GlobalKey<FormState>();

  final _creditNoteNoController = TextEditingController(text: 'CN-2026-003');
  final _originalInvoiceNoController = TextEditingController();
  final _originalDateController = TextEditingController(text: '15/10/2026');
  final _cnDateController = TextEditingController(text: '24/10/2026');
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCustomer = 'GE T&D INDIA LIMITED';
  String _reason = '01 - Sales Return';
  String _taxRate = '18%';
  String _adjustmentMode = 'Adjust Against Outstanding Invoice';

  static const List<String> _customers = [
    'GE T&D INDIA LIMITED',
    'Sharma Enterprises',
    'Bengal Tech Solutions',
    'Apex Logistics Ltd',
  ];

  static const List<String> _reasons = [
    '01 - Sales Return',
    '02 - Post Sale Discount',
    '03 - Deficiency in Services',
    '04 - Correction in Invoice',
    '05 - Change in POS',
    '06 - Final Settlement Adjustment',
  ];

  static const List<String> _taxRates = ['0%', '5%', '12%', '18%', '28%'];

  static const List<String> _adjustmentModes = [
    'Adjust Against Outstanding Invoice',
    'Direct Refund to Customer (Bank/Cash)',
    'Hold as Credit Balance in Customer Ledger',
  ];

  @override
  void dispose() {
    _creditNoteNoController.dispose();
    _originalInvoiceNoController.dispose();
    _originalDateController.dispose();
    _cnDateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Credit Note "${_creditNoteNoController.text}" issued successfully!');
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
          StringManager.createCreditNote,
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
              StringManager.saveCreditNote,
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
              // Customer Selection
              Text(
                'Customer / Buyer *',
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
                    value: _selectedCustomer,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _customers.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCustomer = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Credit Note No & Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _creditNoteNoController,
                      label: 'Credit Note No. *',
                      hintText: 'CN-2026-003',
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
                      controller: _cnDateController,
                      label: 'Credit Note Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Original Invoice Reference
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _originalInvoiceNoController,
                      label: StringManager.originalInvoiceNo,
                      hintText: 'e.g. INV-2026-001',
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
                      label: 'Original Inv Date',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.event_available_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reason Dropdown
              Text(
                StringManager.reasonForReturn,
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

              // Credit Amount & GST Rate
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _amountController,
                      label: 'Credit Taxable Value (₹) *',
                      hintText: 'e.g. 15000',
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

              // Adjustment Mode
              Text(
                'Adjustment Mode *',
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
                    value: _adjustmentMode,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _adjustmentModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _adjustmentMode = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes / Remarks
              GlobalInputField(
                controller: _notesController,
                label: 'Notes / Remarks',
                hintText: 'State return tracking details or reason notes...',
                prefixIcon: Icons.edit_note_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

