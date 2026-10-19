import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';

/// Professional Mobile-optimized Customers Page mirroring the web "Manage Customers" view with modern card approach and Floating Add Customer action.
class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<CustomerModel> _customers = [
    CustomerModel(
      siNo: 1,
      type: 'B2B',
      customerName: 'GE T&D INDIA LIMITED',
      companyName: 'GE Power Systems',
      email: 'contact@ged.com',
      phoneNumber: '+91 94773 17207',
      gstin: '05AAACG2115R1ZN',
      pan: 'AAACG2115R',
      totalAmount: '₹ 1,45,000.00',
      totalReceived: '₹ 1,20,000.00',
      totalDue: '₹ 25,000.00',
      status: 'Active',
    ),
    CustomerModel(
      siNo: 2,
      type: 'B2C',
      customerName: 'Aarav Sharma',
      companyName: 'Sharma Enterprises',
      email: 'aarav.sharma@gmail.com',
      phoneNumber: '+91 98765 43210',
      gstin: '07AABCS1429B1Z8',
      pan: 'AABCS1429B',
      totalAmount: '₹ 48,500.00',
      totalReceived: '₹ 48,500.00',
      totalDue: '₹ 0.00',
      status: 'Active',
    ),
    CustomerModel(
      siNo: 3,
      type: 'B2B',
      customerName: 'Priya Mukherjee',
      companyName: 'Bengal Tech Solutions',
      email: 'info@bengaltech.io',
      phoneNumber: '+91 91234 56789',
      gstin: '19AABCB2231C1ZS',
      pan: 'AABCB2231C',
      totalAmount: '₹ 2,80,000.00',
      totalReceived: '₹ 1,50,000.00',
      totalDue: '₹ 1,30,000.00',
      status: 'Pending',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Manage Customers',
          style: getBoldStyle(
            fontSize: FontManager.s20,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          // Add Customer (+) Button linked to AddCustomerPage
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ColorManager.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
            onPressed: () => context.push(AppRouter.addCustomer),
            tooltip: 'Add Customer',
          ),
          // Filter Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 18),
            ),
            onPressed: () => context.showSnackBar('Filter options clicked'),
            tooltip: 'Filter',
          ),
          // Refresh Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
            ),
            onPressed: () => context.showSnackBar('Customer list refreshed'),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.addCustomer),
        backgroundColor: ColorManager.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Customer', style: getBoldStyle(fontSize: FontManager.s14, color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Import Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? ColorManager.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                        decoration: const InputDecoration(
                          hintText: 'Search customer, GSTIN or email...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.showSnackBar('Import customers clicked'),
                    icon: const Icon(Icons.upload_file_rounded, size: 18, color: Colors.white),
                    label: Text('Import', style: getBoldStyle(fontSize: FontManager.s13, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),

            // Customer List Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? ColorManager.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? ColorManager.darkBorder : Colors.grey.withValues(alpha: 0.15),
                      ),
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
                        // Top Row: Name, Type Badge & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: ColorManager.primaryGreen.withValues(alpha: 0.15),
                                    child: Text(
                                      customer.customerName.substring(0, 1),
                                      style: getBoldStyle(fontSize: FontManager.s14, color: ColorManager.primaryGreen),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customer.customerName,
                                          style: getBoldStyle(
                                            fontSize: FontManager.s16,
                                            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          customer.companyName,
                                          style: getRegularStyle(
                                            fontSize: FontManager.s12,
                                            color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: customer.type == 'B2B' ? Colors.blue.withValues(alpha: 0.15) : Colors.purple.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                customer.type,
                                style: getBoldStyle(
                                  fontSize: FontManager.s12,
                                  color: customer.type == 'B2B' ? Colors.blue : Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 14),

                        // Contact & Tax Info Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(Icons.email_outlined, customer.email, isDark),
                            ),
                            Expanded(
                              child: _buildInfoItem(Icons.phone_outlined, customer.phoneNumber, isDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(Icons.receipt_long_outlined, 'GSTIN: ${customer.gstin}', isDark),
                            ),
                            Expanded(
                              child: _buildInfoItem(Icons.credit_card_outlined, 'PAN: ${customer.pan}', isDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 14),

                        // Financial Summary Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFinancialSummary('Total', customer.totalAmount, Colors.blue, isDark),
                            _buildFinancialSummary('Received', customer.totalReceived, Colors.green, isDark),
                            _buildFinancialSummary('Due', customer.totalDue, Colors.red, isDark),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 14, color: ColorManager.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontSize: FontManager.s12,
              color: isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary(String label, String amount, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getRegularStyle(fontSize: FontManager.s12, color: ColorManager.grey),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: getBoldStyle(
            fontSize: FontManager.s13,
            color: color,
          ),
        ),
      ],
    );
  }
}

class CustomerModel {
  final int siNo;
  final String type;
  final String customerName;
  final String companyName;
  final String email;
  final String phoneNumber;
  final String gstin;
  final String pan;
  final String totalAmount;
  final String totalReceived;
  final String totalDue;
  final String status;

  CustomerModel({
    required this.siNo,
    required this.type,
    required this.customerName,
    required this.companyName,
    required this.email,
    required this.phoneNumber,
    required this.gstin,
    required this.pan,
    required this.totalAmount,
    required this.totalReceived,
    required this.totalDue,
    required this.status,
  });
}
