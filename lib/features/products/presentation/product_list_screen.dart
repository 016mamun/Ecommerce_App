import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../domain/providers/product_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/providers/app_mode_provider.dart';
import '../../pharmacy/domain/providers/medicine_provider.dart';
import '../../pharmacy/presentation/widgets/medicine_card.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String category;
  const ProductListScreen({super.key, this.category = ''});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(productFilterProvider.notifier).state =
            ProductFilter(category: widget.category);
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appMode = ref.watch(appModeProvider);
    final isPharmacy = appMode == AppMode.pharmacy;
    
    final filter = ref.watch(productFilterProvider);
    final productsAsync = ref.watch(filteredProductsProvider);
    final medicinesAsync = ref.watch(filteredMedicinesProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        leading: GestureDetector(
          onTap: () => context.go('/home'),
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        title: Text(
          isPharmacy 
              ? 'Medicines' 
              : filter.category.isEmpty ? AppStrings.explore : filter.category,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!isPharmacy)
            GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                margin: const EdgeInsets.only(right: AppSizes.md),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.setting_4, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Filter', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.md),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: context.textPrimaryColor, fontSize: 14),
              onChanged: (v) {
                if (isPharmacy) {
                  ref.read(medicineSearchQueryProvider.notifier).state = v;
                } else {
                  ref.read(searchQueryProvider.notifier).state = v;
                }
              },
              decoration: InputDecoration(
                hintText: isPharmacy ? 'Search medicines...' : AppStrings.searchHint,
                hintStyle: TextStyle(color: context.textMutedColor, fontSize: 14),
                prefixIcon: Icon(Iconsax.search_normal, color: context.textMutedColor, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          if (isPharmacy) {
                            ref.read(medicineSearchQueryProvider.notifier).state = '';
                          } else {
                            ref.read(searchQueryProvider.notifier).state = '';
                          }
                          setState(() {});
                        },
                        child: Icon(Icons.close, color: context.textMutedColor, size: 18),
                      )
                    : null,
              ),
            ),
          ),

          // Sort Chips
          if (!isPharmacy)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                children: [
                  _SortChip(label: 'Popular', value: 'popularity', current: filter.sortBy),
                  _SortChip(label: 'Price ↑', value: 'price_asc', current: filter.sortBy),
                  _SortChip(label: 'Price ↓', value: 'price_desc', current: filter.sortBy),
                  _SortChip(label: 'Rating', value: 'rating', current: filter.sortBy),
                ],
              ),
            ),
          if (!isPharmacy) const SizedBox(height: AppSizes.md),

          // Products / Medicines Grid
          Expanded(
            child: isPharmacy
                ? medicinesAsync.when(
                    loading: () => GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, __) => const ShimmerProductCard(), // We can reuse shimmer for now
                    ),
                    error: (_, __) => const Center(
                      child: Text('Something went wrong', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    data: (medicines) {
                      if (medicines.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.search_normal, color: AppColors.textMuted, size: 56),
                              SizedBox(height: 12),
                              Text('No medicines found', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return MedicineCard(
                            medicine: medicine,
                            onTap: () => context.push('/pharmacy/medicine/${medicine.id}'),
                          );
                        },
                      );
                    },
                  )
                : productsAsync.when(
                    loading: () => GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, __) => const ShimmerProductCard(),
                    ),
                    error: (_, __) => const Center(
                      child: Text('Something went wrong', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    data: (products) {
                      if (products.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.search_normal, color: AppColors.textMuted, size: 56),
                              SizedBox(height: 12),
                              Text('No products found', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/products/${product.id}'),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends ConsumerWidget {
  final String label;
  final String value;
  final String current;

  const _SortChip({required this.label, required this.value, required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = current == value;
    return GestureDetector(
      onTap: () {
        ref.read(productFilterProvider.notifier).state =
            ref.read(productFilterProvider).copyWith(sortBy: value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])
              : null,
          color: isSelected ? null : context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : context.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Filter Bottom Sheet ─────────────────────────────────────────────────────
class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 150000);
  double _minRating = 0;
  String? _selectedCategory;

  final _categories = ['Electronics', 'Fashion', 'Footwear', 'Beauty', 'Home', 'Sports', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xxl),
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text('Filter & Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor)),
            const SizedBox(height: AppSizes.lg),

            // Category
            Text('Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textSecondaryColor)),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = isSelected ? null : cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])
                          : null,
                      color: isSelected ? null : context.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? Colors.transparent : context.borderColor),
                    ),
                    child: Text(cat, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textSecondary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.lg),

            // Price Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price Range', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                Text(
                  '৳${_priceRange.start.toInt()} – ৳${_priceRange.end.toInt()}',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 150000,
              divisions: 100,
              activeColor: AppColors.primary,
              inactiveColor: context.borderColor,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
            const SizedBox(height: AppSizes.md),

            // Min Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Minimum Rating', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                Row(
                  children: [
                    const Icon(Iconsax.star5, color: Color(0xFFFFB800), size: 14),
                    const SizedBox(width: 4),
                    Text(_minRating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: AppColors.primary,
              inactiveColor: context.borderColor,
              onChanged: (v) => setState(() => _minRating = v),
            ),
            const SizedBox(height: AppSizes.lg),

            // Apply Button
            ElevatedButton(
              onPressed: () {
                ref.read(productFilterProvider.notifier).state = ProductFilter(
                  category: _selectedCategory ?? '',
                  minPrice: _priceRange.start > 0 ? _priceRange.start : null,
                  maxPrice: _priceRange.end < 150000 ? _priceRange.end : null,
                  minRating: _minRating > 0 ? _minRating : null,
                  sortBy: ref.read(productFilterProvider).sortBy,
                );
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
