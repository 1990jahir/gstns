import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/global_input_field.dart';

/// Modern Add Item / Product / Service Form Page.
class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  String _itemType = 'Goods'; // 'Goods' or 'Services'
  String _unit = 'Pcs';
  String _taxSlab = '18%';

  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _hsnController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _minStockAlertController = TextEditingController();

  static const List<String> _units = ['Pcs', 'Kgs', 'Mtr', 'Box', 'Nos', 'Ltr'];
  static const List<String> _taxSlabs = ['0%', '5%', '12%', '18%', '28%'];

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _hsnController.dispose();
    _salePriceController.dispose();
    _purchasePriceController.dispose();
    _openingStockController.dispose();
    _minStockAlertController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.showSnackBar('Item "${_nameController.text}" created successfully!');
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
          StringManager.addItem,
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
              'Save Item',
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
              // Item Type Toggle (Goods vs Service)
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: ['Goods', 'Services'].map((type) {
                    final isSelected = _itemType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _itemType = type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isSelected
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? ColorManager.primaryGreen
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Basic Info Card
              _buildCard(
                title: 'Basic Information',
                isDark: isDark,
                children: [
                  GlobalInputField(
                    label: 'Item / Product Name *',
                    hintText: 'e.g. Copper Cable 4 sq mm',
                    prefixIcon: Icons.inventory_2_outlined,
                    controller: _nameController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Item name is required' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'SKU / Item Code',
                          hintText: 'e.g. CBL-CU-4MM',
                          prefixIcon: Icons.qr_code_rounded,
                          controller: _skuController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: _itemType == 'Goods' ? 'HSN Code *' : 'SAC Code *',
                          hintText: _itemType == 'Goods' ? 'e.g. 8544' : 'e.g. 9983',
                          prefixIcon: Icons.numbers_rounded,
                          controller: _hsnController,
                          validator: (v) => v == null || v.trim().isEmpty ? 'HSN/SAC required' : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pricing & Tax Card
              _buildCard(
                title: 'Pricing & GST Tax',
                isDark: isDark,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GlobalInputField(
                          label: 'Selling Price (₹) *',
                          hintText: '0.00',
                          prefixIcon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          controller: _salePriceController,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Price required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlobalInputField(
                          label: 'Purchase Price (₹)',
                          hintText: '0.00',
                          prefixIcon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          controller: _purchasePriceController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Unit of Measure',
                          value: _unit,
                          items: _units,
                          onChanged: (val) => setState(() => _unit = val!),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'GST Tax Slab',
                          value: _taxSlab,
                          items: _taxSlabs,
                          onChanged: (val) => setState(() => _taxSlab = val!),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stock Management (Only for Goods)
              if (_itemType == 'Goods')
                _buildCard(
                  title: 'Inventory & Stock Alert',
                  isDark: isDark,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GlobalInputField(
                            label: 'Opening Stock',
                            hintText: '0',
                            prefixIcon: Icons.all_inbox_rounded,
                            keyboardType: TextInputType.number,
                            controller: _openingStockController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GlobalInputField(
                            label: 'Low Stock Alert Threshold',
                            hintText: '10',
                            prefixIcon: Icons.warning_amber_rounded,
                            keyboardType: TextInputType.number,
                            controller: _minStockAlertController,
                          ),
                        ),
                      ],
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
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

