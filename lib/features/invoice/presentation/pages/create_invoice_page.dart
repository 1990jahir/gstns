import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/global_input_field.dart';
import '../../../../core/widgets/global_loader.dart';

/// Modern Create Invoice Page mirroring the web reference form ("Supply Type", "Vendor Name", "Item Details", "Summary", "Transport Details").
class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();

  String _supplyType = 'Inward';
  String _subType = 'Supply';
  String _documentType = 'Tax Invoice';
  String _vendorName = 'GE T&D INDIA LIMITED';

  final _invoiceNoController = TextEditingController(text: 'URP/2026-27/1');
  final _invoiceDateController = TextEditingController(text: '16/10/2026');
  final _dueDateController = TextEditingController(text: '20/10/2026');
  final _itemRateController = TextEditingController(text: '45454545');
  final _itemQtyController = TextEditingController(text: '1');
  final _transporterController = TextEditingController();
  final _distanceController = TextEditingController(text: '0');

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _invoiceDateController.dispose();
    _dueDateController.dispose();
    _itemRateController.dispose();
    _itemQtyController.dispose();
    _transporterController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      GlobalLoader.show(context, message: 'Creating purchase invoice...');
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        GlobalLoader.hide(context);
        context.showSnackBar('Purchase Invoice created successfully!');
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
          'Create Purchase Invoice',
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
              // Section 1: Supply & Document Details
              _buildSectionCard(
                title: 'Supply & Document Details',
                isDark: isDark,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField('Supply Type *', _supplyType, ['Inward', 'Outward'], (val) => setState(() => _supplyType = val!))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDropdownField('Sub Type *', _subType, ['Supply', 'Job Work', 'Export'], (val) => setState(() => _subType = val!))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField('Document Type *', _documentType, ['Tax Invoice', 'Bill of Supply', 'Delivery Challan'], (val) => setState(() => _documentType = val!))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField('Vendor Name *', _vendorName, ['GE T&D INDIA LIMITED', 'Sharma Enterprises', 'Bengal Tech Solutions'], (val) => setState(() => _vendorName = val!)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Invoice Dates & Numbers
              _buildSectionCard(
                title: 'Invoice Numbers & Dates',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: 'Invoice No. *',
                    hintText: 'Invoice No.',
                    controller: _invoiceNoController,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'Invoice Date *',
                          hintText: 'DD/MM/YYYY',
                          controller: _invoiceDateController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: 'Due Date *',
                          hintText: 'DD/MM/YYYY',
                          controller: _dueDateController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Item Details
              _buildSectionCard(
                title: 'Item Details',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: 'Rate (₹) *',
                    hintText: '0.00',
                    controller: _itemRateController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  GlobalInputField(
                    label: 'Quantity *',
                    hintText: '1',
                    controller: _itemQtyController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 4: Transportation Details
              _buildSectionCard(
                title: 'Transportation Details',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: 'Transporter Name',
                    hintText: 'Transporter',
                    controller: _transporterController,
                  ),
                  const SizedBox(height: 16),
                  GlobalInputField(
                    label: 'Distance (KM) *',
                    hintText: '0',
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
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
                      child: Text('Cancel', style: getBoldStyle(fontSize: FontManager.s15, color: Colors.red.shade600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Save Invoice',
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
