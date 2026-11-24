import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/res/color_manager.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/web_empty_state.dart';
import '../../../../core/widgets/web_filter_toolbar.dart';
import '../../../../core/widgets/web_refresh_button.dart';
import '../../../../core/widgets/web_section_banner.dart';
import '../providers/masters_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/item_card.dart';

/// Modern Manage Items Page with Dual Tabs ([ Category ] vs [ Item ])
/// matching the exact GSTSOF web portal screenshot layout.
class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(itemSelectedTabProvider); // 0 = Category, 1 = Item
    final items = ref.watch(filteredItemsProvider);
    final categories = ref.watch(filteredCategoriesProvider);
    final entriesPerPage = ref.watch(itemEntriesPerPageProvider);
    final searchBy = ref.watch(itemSearchByProvider);
    final searchQuery = ref.watch(itemSearchQueryProvider);
    final startDate = ref.watch(itemStartDateProvider);
    final endDate = ref.watch(itemEndDateProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          StringManager.manageItems,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark ? ColorManager.darkCard : Colors.white,
        elevation: 0,
        actions: [
          WebRefreshButton(
            onRefresh: () => context.showSnackBar('Refreshing inventory items...'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Filter Toolbar: Show [50], Start Date, End Date, Search By, Search Input
            WebFilterToolbar(
              entriesPerPage: entriesPerPage,
              onEntriesPerPageChanged: (val) {
                if (val != null) ref.read(itemEntriesPerPageProvider.notifier).state = val;
              },
              startDate: startDate,
              onStartDateChanged: (val) => ref.read(itemStartDateProvider.notifier).state = val,
              endDate: endDate,
              onEndDateChanged: (val) => ref.read(itemEndDateProvider.notifier).state = val,
              onDateSearchPressed: () => context.showSnackBar('Applying item date filters...'),
              searchBy: searchBy,
              searchByOptions: const ['Item Name', 'HSN/SAC', 'SKU'],
              onSearchByChanged: (val) {
                if (val != null) ref.read(itemSearchByProvider.notifier).state = val;
              },
              searchQuery: searchQuery,
              onSearchQueryChanged: (val) => ref.read(itemSearchQueryProvider.notifier).state = val,
              searchHint: 'Search inventory items...',
            ),

            // Dual Tab Row: [ Category ] [ Item ] matching web screenshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => ref.read(itemSelectedTabProvider.notifier).state = 0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTab == 0
                            ? ColorManager.primaryGreen.withValues(alpha: 0.14)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTab == 0 ? ColorManager.primaryGreen : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 18,
                            color: selectedTab == 0 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            StringManager.categoryTab,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                              color: selectedTab == 0 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  InkWell(
                    onTap: () => ref.read(itemSelectedTabProvider.notifier).state = 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTab == 1
                            ? ColorManager.primaryGreen.withValues(alpha: 0.14)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTab == 1 ? ColorManager.primaryGreen : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            size: 18,
                            color: selectedTab == 1 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            StringManager.itemTab,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                              color: selectedTab == 1 ? ColorManager.primaryGreen : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Green Box Section Header Banner
            WebSectionBanner(
              icon: selectedTab == 1 ? Icons.inventory_2_rounded : Icons.category_rounded,
              title: selectedTab == 1 ? 'Inventory Items' : 'Item Categories',
              subtitle: selectedTab == 1 ? StringManager.itemsSubtitle : 'Manage product groups & tax categories',
              actionLabel: selectedTab == 1 ? StringManager.addItem : StringManager.addCategory,
              onActionPressed: () {
                if (selectedTab == 1) {
                  context.push(AppRouter.addItem);
                } else {
                  context.push(AppRouter.addCategory);
                }
              },
            ),

            // Tab Content
            Expanded(
              child: selectedTab == 1
                  ? (items.isEmpty
                      ? const WebEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ItemCard(item: items[index]);
                          },
                        ))
                  : (categories.isEmpty
                      ? const WebEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(category: categories[index]);
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
