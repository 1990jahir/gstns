import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Add / Link Bank Account Page matching website fields.
class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _holderController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _confirmAccountNoController = TextEditingController();
  final _ifscController = TextEditingController();
  final _branchController = TextEditingController();
  final _openingBalanceController = TextEditingController(text: '0.00');

  String _bankName = 'HDFC Bank';
  String _accountType = 'Current Account';
  bool _isDefaultAccount = true;

  static const List<String> _banks = [
    'HDFC Bank',
    'State Bank of India',
    'ICICI Bank',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Punjab National Bank',
    'Bank of Baroda',
    'Federal Bank',
  ];

  static const List<String> _accountTypes = [
    'Current Account',
    'Savings Account',
    'Cash Credit / Overdraft',
    'Escrow Account',
  ];

  @override
  void dispose() {
    _holderController.dispose();
    _accountNoController.dispose();
    _confirmAccountNoController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_accountNoController.text.trim() != _confirmAccountNoController.text.trim()) {
        context.showSnackBar('Account numbers do not match', isError: true);
        return;
      }
      context.showSnackBar('Bank Account "${_holderController.text}" linked successfully!');
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
          StringManager.addBankAccount,
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
              StringManager.saveBankAccount,
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
              // Display / Holder Name
              GlobalInputField(
                controller: _holderController,
                label: StringManager.accountHolderName,
                hintText: 'e.g. SB Enterprises - Operating',
                prefixIcon: Icons.badge_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bank Name Dropdown
              Text(
                StringManager.bankNameLabel,
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
                    value: _bankName,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _bankName = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Account Type
              Text(
                StringManager.accountTypeLabel,
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
                    value: _accountType,
                    isExpanded: true,
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    items: _accountTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _accountType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Account Number & Confirm
              GlobalInputField(
                controller: _accountNoController,
                label: StringManager.accountNumberLabel,
                hintText: 'e.g. 50200012345678',
                prefixIcon: Icons.account_balance_rounded,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              GlobalInputField(
                controller: _confirmAccountNoController,
                label: StringManager.confirmAccountNumberLabel,
                hintText: 'Re-enter account number',
                prefixIcon: Icons.check_circle_outline_rounded,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // IFSC & Branch
              Row(
                children: [
                  Expanded(
                    child: GlobalInputField(
                      controller: _ifscController,
                      label: StringManager.ifscCodeLabel,
                      hintText: 'HDFC0001234',
                      prefixIcon: Icons.password_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return StringManager.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalInputField(
                      controller: _branchController,
                      label: StringManager.branchLabel,
                      hintText: 'Salt Lake Sector V',
                      prefixIcon: Icons.location_on_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Opening Balance
              GlobalInputField(
                controller: _openingBalanceController,
                label: 'Opening Balance (₹)',
                hintText: '0.00',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Default Account Toggle
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
                          'Primary Account for Invoices',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Bank details will print on customer PDF invoices',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isDefaultAccount,
                      activeTrackColor: ColorManager.primaryGreen,
                      onChanged: (val) => setState(() => _isDefaultAccount = val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

