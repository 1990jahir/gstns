import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/color_manager.dart';

/// Presentation model representing an Item matching the GSTSOF web table columns:
/// SL. No, Action, Item Name, SKU/Code, HSN/SAC, Category, Unit, Sale Price, Purchase Price, Tax Rate, Stock Status
class ItemModel {
  final int slNo;
  final String name;
  final String sku;
  final String hsn;
  final String category;
  final String unit;
  final String salePrice;
  final String purchasePrice;
  final String taxRate;
  final String stock;
  final String status;
  final Color statusColor;

  const ItemModel({
    required this.slNo,
    required this.name,
    required this.sku,
    required this.hsn,
    required this.category,
    required this.unit,
    required this.salePrice,
    required this.purchasePrice,
    required this.taxRate,
    required this.stock,
    required this.status,
    required this.statusColor,
  });
}

class CategoryModel {
  final int slNo;
  final String name;
  final String itemCount;
  final IconData icon;
  final Color color;
  final List<String> subCategories;

  const CategoryModel({
    required this.slNo,
    required this.name,
    required this.itemCount,
    required this.icon,
    required this.color,
    required this.subCategories,
  });
}

class TransporterModel {
  final int slNo;
  final String name;
  final String transporterId;
  final String contactPerson;
  final String phone;
  final String activeVehicles;
  final String status;

  const TransporterModel({
    required this.slNo,
    required this.name,
    required this.transporterId,
    required this.contactPerson,
    required this.phone,
    required this.activeVehicles,
    required this.status,
  });
}

final goodsListProvider = Provider<List<ItemModel>>((ref) {
  return const [
    ItemModel(
      slNo: 1,
      name: 'Circuit Breaker 16A 3-Phase',
      sku: 'CB-16A-3P',
      hsn: '8536',
      category: 'Switchgears',
      unit: 'Pcs',
      salePrice: '₹ 1,850.00',
      purchasePrice: '₹ 1,450.00',
      taxRate: '18%',
      stock: '142 Pcs',
      status: 'In Stock',
      statusColor: ColorManager.primaryGreen,
    ),
    ItemModel(
      slNo: 2,
      name: 'Industrial Copper Cable 4 sq mm',
      sku: 'CBL-CU-4MM',
      hsn: '8544',
      category: 'Cables & Wires',
      unit: 'Mtr',
      salePrice: '₹ 420.00',
      purchasePrice: '₹ 340.00',
      taxRate: '18%',
      stock: '18 Mtr',
      status: 'Low Stock',
      statusColor: Colors.orange,
    ),
    ItemModel(
      slNo: 3,
      name: 'Transformer Oil Grade A (210L Drum)',
      sku: 'TR-OIL-210L',
      hsn: '2710',
      category: 'Lubricants & Oils',
      unit: 'Drum',
      salePrice: '₹ 28,500.00',
      purchasePrice: '₹ 24,000.00',
      taxRate: '18%',
      stock: '0 Drum',
      status: 'Out of Stock',
      statusColor: Colors.redAccent,
    ),
  ];
});

final categoriesListProvider = Provider<List<CategoryModel>>((ref) {
  return const [
    CategoryModel(
      slNo: 1,
      name: 'Switchgears & Protection',
      itemCount: '24 Items',
      icon: Icons.electric_bolt_rounded,
      color: Colors.amber,
      subCategories: ['MCB', 'MCCB', 'RCCB', 'Relays'],
    ),
    CategoryModel(
      slNo: 2,
      name: 'Cables & Heavy Wires',
      itemCount: '58 Items',
      icon: Icons.cable_rounded,
      color: Colors.blue,
      subCategories: ['Armoured', 'Flexible', 'Control Cable'],
    ),
    CategoryModel(
      slNo: 3,
      name: 'Transformers & Substations',
      itemCount: '12 Items',
      icon: Icons.power_rounded,
      color: ColorManager.primaryGreen,
      subCategories: ['Distribution', 'Current Transformer', 'Potential Transformer'],
    ),
  ];
});

final transportersListProvider = Provider<List<TransporterModel>>((ref) {
  return const [
    TransporterModel(
      slNo: 1,
      name: 'Apex Super Cargo Logistics',
      transporterId: '19AAACA1122D1Z4',
      contactPerson: 'Manoj Verma',
      phone: '+91 98300 44556',
      activeVehicles: '14 Trucks',
      status: 'Active',
    ),
    TransporterModel(
      slNo: 2,
      name: 'Eastern Interstate Roadlines',
      transporterId: '27AABCE3344F1Z8',
      contactPerson: 'Suresh Das',
      phone: '+91 97488 22113',
      activeVehicles: '8 Trailers',
      status: 'Active',
    ),
  ];
});

// Dual Tab state for Items Page (0 = Category, 1 = Item)
final itemSelectedTabProvider = StateProvider<int>((ref) => 1);

// Filter & Search Providers for Items
final itemEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final itemStartDateProvider = StateProvider<String>((ref) => '');
final itemEndDateProvider = StateProvider<String>((ref) => '');
final itemSearchByProvider = StateProvider<String>((ref) => 'Item Name');
final itemSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredItemsProvider = Provider<List<ItemModel>>((ref) {
  final items = ref.watch(goodsListProvider);
  final query = ref.watch(itemSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(itemSearchByProvider);

  if (query.isEmpty) return items;

  return items.where((it) {
    if (searchBy == 'HSN/SAC') {
      return it.hsn.toLowerCase().contains(query);
    } else if (searchBy == 'SKU') {
      return it.sku.toLowerCase().contains(query);
    } else {
      return it.name.toLowerCase().contains(query);
    }
  }).toList();
});

final filteredCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final cats = ref.watch(categoriesListProvider);
  final query = ref.watch(itemSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return cats;
  return cats.where((c) => c.name.toLowerCase().contains(query)).toList();
});

// Filter & Search Providers for Transporters
final transporterEntriesPerPageProvider = StateProvider<int>((ref) => 50);
final transporterStartDateProvider = StateProvider<String>((ref) => '');
final transporterEndDateProvider = StateProvider<String>((ref) => '');
final transporterSearchByProvider = StateProvider<String>((ref) => 'Transporter Name');
final transporterSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTransportersProvider = Provider<List<TransporterModel>>((ref) {
  final transporters = ref.watch(transportersListProvider);
  final query = ref.watch(transporterSearchQueryProvider).trim().toLowerCase();
  final searchBy = ref.watch(transporterSearchByProvider);

  if (query.isEmpty) return transporters;

  return transporters.where((t) {
    if (searchBy == 'Transporter ID') {
      return t.transporterId.toLowerCase().contains(query);
    } else if (searchBy == 'Phone') {
      return t.phone.replaceAll(' ', '').contains(query);
    } else {
      return t.name.toLowerCase().contains(query) || t.contactPerson.toLowerCase().contains(query);
    }
  }).toList();
});
