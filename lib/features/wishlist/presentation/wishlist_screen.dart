import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../domain/providers/wishlist_provider.dart';
import '../../products/domain/providers/product_provider.dart';
import '../../products/data/models/product_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/shimmer_loader.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistIds = ref.watch(wishlistProvider);
    final allProductsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.bgColor,
        title: Text(
          '${AppStrings.wishlist} (${wishlistIds.length})',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (wishlistIds.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(wishlistProvider.notifier).clear(),
              child: const Text('Clear All', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: wishlistIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Icon(Iconsax.heart, color: context.textMutedColor, size: 46),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text('Your wishlist is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor)),
                  const SizedBox(height: 6),
                  Text('Save items you love here', style: TextStyle(fontSize: 13, color: context.textSecondaryColor)),
                  const SizedBox(height: AppSizes.lg),
                  GestureDetector(
                    onTap: () => context.go('/explore'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.primary]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Explore Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            )
          : allProductsAsync.when(
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(AppSizes.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: 4,
                itemBuilder: (_, __) => const ShimmerProductCard(),
              ),
              error: (_, __) => const Center(child: Text('Error loading wishlist')),
              data: (allProducts) {
                final wishlistProducts = allProducts.where((p) => wishlistIds.contains(p.id)).toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: wishlistProducts.length,
                  itemBuilder: (context, index) {
                    final product = wishlistProducts[index];
                    return _WishlistProductCard(product: product);
                  },
                );
              },
            ),
    );
  }
}

class _WishlistProductCard extends ConsumerWidget {
  final ProductModel product;
  const _WishlistProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrls.first,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const ShimmerLoader(width: double.infinity, height: double.infinity, borderRadius: 0),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => ref.read(wishlistProvider.notifier).toggle(product.id),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Iconsax.heart5, color: AppColors.secondary, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textPrimaryColor)),
                  const SizedBox(height: 4),
                  Text('৳${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
