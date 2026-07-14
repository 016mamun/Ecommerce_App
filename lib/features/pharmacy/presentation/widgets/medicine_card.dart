import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/models/medicine_model.dart';
import '../../../wishlist/domain/providers/wishlist_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/shimmer_loader.dart';

/// A compact, pharmacy-branded medicine card used in grids and lists.
class MedicineCard extends ConsumerWidget {
  final MedicineModel medicine;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistIds = ref.watch(wishlistProvider);
    final isWishlisted = wishlistIds.contains(medicine.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + overlay badges ──────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: medicine.imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerLoader(
                      width: double.infinity,
                      height: 130,
                      borderRadius: 0,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 130,
                      color: AppColors.pharmacyLight,
                      child: const Center(
                        child: Icon(
                          Iconsax.health,
                          size: 48,
                          color: AppColors.pharmacyPrimary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Rx badge (top-left)
                if (medicine.isRxRequired)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.rxBadge,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Rx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // Category badge (top-right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _categoryColor(medicine.category),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      medicine.category.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Discount badge (bottom-left)
                if (medicine.hasDiscount)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.pharmacyGradientStart,
                            AppColors.pharmacyGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${medicine.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                // Wishlist heart (bottom-right)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(wishlistProvider.notifier).toggle(medicine.id),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                        key: ValueKey(isWishlisted),
                        color: isWishlisted ? AppColors.rxBadge : Colors.white,
                        size: 22,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Text info ──────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${medicine.genericName} · ${medicine.strength}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: context.textMutedColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '৳${medicine.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pharmacyPrimary,
                          ),
                        ),
                        if (medicine.hasDiscount) ...[
                          const SizedBox(width: 4),
                          Text(
                            '৳${medicine.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.textMutedColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Add to cart button ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: medicine.isAvailable ? onAddToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: medicine.isAvailable
                        ? AppColors.pharmacyPrimary
                        : context.borderColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    medicine.isAvailable ? 'Add' : 'Unavailable',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _categoryColor(MedicineCategory cat) {
    switch (cat) {
      case MedicineCategory.otc:
        return AppColors.otcBadge;
      case MedicineCategory.prescription:
        return AppColors.rxBadge.withOpacity(0.85);
      case MedicineCategory.herbal:
        return AppColors.herbalBadge;
      case MedicineCategory.personalCare:
        return AppColors.personalCareBadge;
    }
  }
}
