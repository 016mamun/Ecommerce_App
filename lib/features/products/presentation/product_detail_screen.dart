import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../domain/providers/product_provider.dart';
import '../../cart/domain/providers/cart_provider.dart';
import '../../wishlist/domain/providers/wishlist_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/shimmer_loader.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _currentImage = 0;
  String? _selectedSize;
  String? _selectedColor;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '৳');

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: productAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              const Text('Product not found', style: TextStyle(color: AppColors.textSecondary)),
              ElevatedButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          _selectedSize ??= product.sizes.isNotEmpty ? product.sizes.first : null;
          _selectedColor ??= product.colors.isNotEmpty ? product.colors.first : null;

          final isWishlisted = ref.watch(wishlistProvider).contains(product.id);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Image carousel app bar
                  SliverAppBar(
                    expandedHeight: 380,
                    pinned: true,
                    backgroundColor: AppColors.darkBg,
                    leading: GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.darkBg.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () => ref.read(wishlistProvider.notifier).toggle(product.id),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.darkBg.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                            color: isWishlisted ? AppColors.secondary : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: product.imageUrls.length,
                            onPageChanged: (i) => setState(() => _currentImage = i),
                            itemBuilder: (_, index) => InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrls[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (_, __) => const ShimmerLoader(
                                  width: double.infinity,
                                  height: double.infinity,
                                  borderRadius: 0,
                                ),
                              ),
                            ),
                          ),
                          // Image indicators
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: product.imageUrls.asMap().entries.map((e) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: _currentImage == e.key ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentImage == e.key
                                        ? AppColors.primary
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.darkBg,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge + Stock
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.category,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: product.isOutOfStock
                                      ? AppColors.error.withOpacity(0.15)
                                      : product.isLowStock
                                          ? AppColors.warning.withOpacity(0.15)
                                          : AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.isOutOfStock
                                      ? AppStrings.outOfStock
                                      : product.isLowStock
                                          ? 'Only ${product.stock} left!'
                                          : AppStrings.inStock,
                                  style: TextStyle(
                                    color: product.isOutOfStock
                                        ? AppColors.error
                                        : product.isLowStock
                                            ? AppColors.warning
                                            : AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.sm),

                          // Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),

                          // Brand + Rating
                          Row(
                            children: [
                              Text(
                                product.brand,
                                style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              const Icon(Iconsax.star5, color: Color(0xFFFFB800), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                ' (${product.reviewCount} reviews)',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.md),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                currency.format(product.price),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (product.originalPrice > product.price) ...[
                                const SizedBox(width: AppSizes.sm),
                                Text(
                                  currency.format(product.originalPrice),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.textMuted,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [AppColors.flashSaleStart, AppColors.flashSaleEnd]),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '-${product.discountPercent}%',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // Size Selector
                          if (product.sizes.isNotEmpty) ...[
                            const Text(AppStrings.selectSize,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            const SizedBox(height: AppSizes.sm),
                            Wrap(
                              spacing: 8,
                              children: product.sizes.map((size) {
                                final isSelected = _selectedSize == size;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedSize = size),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])
                                          : null,
                                      color: isSelected ? null : AppColors.darkCard,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? Colors.transparent : AppColors.darkBorder,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: AppSizes.lg),
                          ],

                          // Color Selector
                          if (product.colors.isNotEmpty) ...[
                            const Text(AppStrings.selectColor,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            const SizedBox(height: AppSizes.sm),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product.colors.map((color) {
                                final isSelected = _selectedColor == color;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedColor = color),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])
                                          : null,
                                      color: isSelected ? null : AppColors.darkCard,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? Colors.transparent : AppColors.darkBorder,
                                      ),
                                    ),
                                    child: Text(
                                      color,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        color: isSelected ? Colors.white : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: AppSizes.lg),
                          ],

                          // Description Tab
                          TabBar(
                            controller: _tabController,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textMuted,
                            indicatorColor: AppColors.primary,
                            dividerColor: AppColors.darkBorder,
                            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            tabs: const [
                              Tab(text: 'Description'),
                              Tab(text: 'Reviews'),
                            ],
                          ),
                          SizedBox(
                            height: 160,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Description
                                Padding(
                                  padding: const EdgeInsets.only(top: AppSizes.md),
                                  child: Text(
                                    product.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                                // Reviews placeholder
                                const Padding(
                                  padding: EdgeInsets.only(top: AppSizes.md),
                                  child: Column(
                                    children: [
                                      _ReviewItem(name: 'Sakib A.', rating: 5, comment: 'Excellent product! Exactly as described. Super fast delivery.'),
                                      Divider(color: AppColors.darkBorder),
                                      _ReviewItem(name: 'Riya M.', rating: 4, comment: 'Good quality. Slightly smaller than expected but overall satisfied.'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── Sticky Bottom CTA ──────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    border: const Border(top: BorderSide(color: AppColors.darkBorder)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          label: AppStrings.addToCart,
                          onPressed: product.isOutOfStock
                              ? null
                              : () {
                                  ref.read(cartProvider.notifier).addItem(
                                        product,
                                        size: _selectedSize,
                                        color: _selectedColor,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart! 🛒'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      GestureDetector(
                        onTap: product.isOutOfStock
                            ? null
                            : () {
                                ref.read(cartProvider.notifier).addItem(
                                      product,
                                      size: _selectedSize,
                                      color: _selectedColor,
                                    );
                                context.push(AppRoutes.checkout);
                              },
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: const Center(
                            child: Text(
                              AppStrings.buyNow,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewItem({required this.name, required this.rating, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating ? Iconsax.star5 : Iconsax.star,
                          size: 10,
                          color: const Color(0xFFFFB800),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
