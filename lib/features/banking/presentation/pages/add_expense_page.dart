import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Add Expense Voucher Page matching website fields.
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  final _expNoController = TextEditingController(text: 'EXP-2026-005');
  final _payeeController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(text: '24/10/2026');
  final _dueDateController = TextEditingController(text: '05/11/2026');
  final _voucherNoController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'Office Supplies';
  String _paymentMode = 'Bank Account';
  String _selectedAccount = 'HDFC Bank - Current (•••• 9012)';
  bool _isGstTaxable = true;
  bool _isItcEligible = true;

  static const List<String> _categories = [
    'Office Supplies',
    'Rent & Utilities',
    'Travel & Fuel',
    'Professional & Legal Fees',
    'Electricity & Water',
    'Advertising & Marketing',
    'Repairs & Maintenance',
    'Staff Salaries & Welfare',
    'Miscellaneous Expenses',
  ];

  static const List<String> _paymentModes = [
    'Bank Account',
    'UPI',
    'Cheque',
    'Cash in Hand',
    'Company Credit Card',
  ];

  static const List<String> _bankAccounts = [
    'HDFC Bank - Current (•••• 9012)',
    'State Bank of India - OD (•••• 4589)',
    'ICICI Bank - Escrow (•••• 7731)',
  ];

  @override
  void dispose() {
    _expNoController.dispose();
    _payeeController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    _voucherNoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Expense of ₹ ${_amountController.text} saved successfully!');
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
          StringManager.addExpense,
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
              StringManager.saveExpense,
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
              // Expense Category
              Text(
                StringManager.expenseCategory,
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
                    value: _category,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _category = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // EXP No. & Expense Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _expNoController,
                      label: 'EXP No. *',
                      hintText: 'EXP-2026-005',
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
                      controller: _dateController,
                      label: 'Expense Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payee / Vendor Name
              GlobalInputField(
                controller: _payeeController,
                label: 'Party / Payee Name *',
                hintText: 'e.g. Prestige Office Space LLP',
                prefixIcon: Icons.storefront_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount & Due Date
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _amountController,
                      label: 'Amount (₹) *',
                      hintText: 'e.g. 45000',
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
                    child: GlobalInputField(
                      controller: _dueDateController,
                      label: 'Due Date *',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icons.event_available_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Mode
              Text(
                'Paid Through / Mode *',
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
                    value: _paymentMode,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _paymentModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMode = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bank Account Selector (if bank selected)
              if (_paymentMode == 'Bank Account') ...[
                Text(
                  'Select Bank Account *',
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
                      value: _selectedAccount,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      items: _bankAccounts.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedAccount = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Voucher / Ref No
              GlobalInputField(
                controller: _voucherNoController,
                label: 'Bill / Voucher / Ref Number',
                hintText: 'e.g. RENT/OCT/2026',
                prefixIcon: Icons.receipt_rounded,
              ),
              const SizedBox(height: 16),

              // GST Taxable & ITC Eligible Switches
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GST Taxable Expense', style: TextStyle(fontWeight: FontWeight.w600)),
                        Switch(
                          value: _isGstTaxable,
                          activeTrackColor: ColorManager.primaryGreen,
                          onChanged: (val) => setState(() => _isGstTaxable = val),
                        ),
                      ],
                    ),
                    if (_isGstTaxable) ...[
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Eligible for Input Tax Credit (ITC)', style: TextStyle(fontWeight: FontWeight.w600)),
                          Switch(
                            value: _isItcEligible,
                            activeTrackColor: ColorManager.primaryGreen,
                            onChanged: (val) => setState(() => _isItcEligible = val),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes / Narration
              GlobalInputField(
                controller: _notesController,
                label: 'Notes / Narration',
                hintText: 'Add description for accounting audit...',
                prefixIcon: Icons.edit_note_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

