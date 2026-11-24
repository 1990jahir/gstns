import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Record Payment Voucher Page.
class RecordPaymentPage extends StatefulWidget {
  const RecordPaymentPage({super.key});

  @override
  State<RecordPaymentPage> createState() => _RecordPaymentPageState();
}

class _RecordPaymentPageState extends State<RecordPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String _paymentType = 'Received'; // 'Received' (Inward) or 'Paid' (Outward)
  String _paymentMode = 'NEFT/RTGS';
  String _selectedAccount = 'HDFC Bank - Current A/C (•••• 9012)';

  final _partyController = TextEditingController(text: 'GE T&D INDIA LIMITED');
  final _amountController = TextEditingController(text: '120000');
  final _refController = TextEditingController();
  final _notesController = TextEditingController();

  static const List<String> _modes = ['UPI', 'NEFT/RTGS', 'Net Banking', 'Cheque', 'Cash'];
  static const List<String> _accounts = [
    'HDFC Bank - Current A/C (•••• 9012)',
    'State Bank of India - OD A/C (•••• 4589)',
    'ICICI Bank - Escrow A/C (•••• 7731)',
    'Cash in Hand',
  ];

  @override
  void dispose() {
    _partyController.dispose();
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Payment of ₹ ${_amountController.text} recorded successfully!');
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
          StringManager.recordPayment,
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
              'Save Payment Voucher',
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
              // Payment Type Toggle (Received vs Paid)
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _paymentType = 'Received'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: _paymentType == 'Received'
                                ? (_paymentType == 'Received' ? ColorManager.primaryGreen : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_downward_rounded, size: 16, color: _paymentType == 'Received' ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                                const SizedBox(width: 6),
                                Text(
                                  'Payment Received (Inward)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _paymentType == 'Received' ? FontWeight.w700 : FontWeight.w500,
                                    color: _paymentType == 'Received' ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _paymentType = 'Paid'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: _paymentType == 'Paid'
                                ? Colors.redAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_upward_rounded, size: 16, color: _paymentType == 'Paid' ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                                const SizedBox(width: 6),
                                Text(
                                  'Payment Made (Outward)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _paymentType == 'Paid' ? FontWeight.w700 : FontWeight.w500,
                                    color: _paymentType == 'Paid' ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Voucher Details Card
              _buildCard(
                title: 'Transaction Details',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: _paymentType == 'Received' ? 'Customer / Payer Name *' : 'Vendor / Beneficiary Name *',
                    hintText: 'Select or type party name',
                    prefixIcon: Icons.person_outline_rounded,
                    controller: _partyController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Party name required' : null,
                  ),
                  const SizedBox(height: 14),
                  GlobalInputField(
                    label: 'Amount (₹) *',
                    hintText: '0.00',
                    prefixIcon: Icons.currency_rupee_rounded,
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Amount required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown(
                    label: 'Payment Mode',
                    value: _paymentMode,
                    items: _modes,
                    onChanged: (val) => setState(() => _paymentMode = val!),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown(
                    label: _paymentType == 'Received' ? 'Deposit Into Bank A/C' : 'Paid From Bank A/C',
                    value: _selectedAccount,
                    items: _accounts,
                    onChanged: (val) => setState(() => _selectedAccount = val!),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),
                  GlobalInputField(
                    label: 'Transaction Ref / UTR / Cheque No.',
                    hintText: 'e.g. UTR: HDFC2610249912',
                    prefixIcon: Icons.receipt_long_rounded,
                    controller: _refController,
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

