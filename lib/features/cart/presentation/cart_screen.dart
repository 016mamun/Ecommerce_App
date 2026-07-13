import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../domain/providers/cart_provider.dart';
import '../data/models/cart_item_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/shimmer_loader.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoCtrl = TextEditingController();
  bool _promoApplied = false;
  String? _promoError;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final error = applyPromoCode(ref, _promoCtrl.text);
    setState(() {
      _promoError = error;
      _promoApplied = error == null && _promoCtrl.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '৳');

    // These derived providers only rebuild when their specific value changes
    final subtotal = ref.watch(cartSubtotalProvider);
    final delivery = ref.watch(cartDeliveryFeeProvider);
    final tax = ref.watch(cartTaxProvider);
    final discount = ref.watch(promoDiscountProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Consumer(
          builder: (_, ref, __) {
            final count = ref.watch(cartCountProvider);
            return Text(
              '${AppStrings.myCart} ${count > 0 ? '($count)' : ''}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            );
          },
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: const Text('Clear', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _CartItemCard(item: cartItems[index]);
                    },
                  ),
                ),

                // Order Summary
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: const Border(top: BorderSide(color: AppColors.darkBorder)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Promo Code
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoCtrl,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Enter promo code (e.g. SAVE10)',
                                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                prefixIcon: const Icon(Iconsax.ticket_discount, color: AppColors.textMuted, size: 18),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                errorText: _promoError,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _applyPromo,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryLight],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _promoApplied ? 'Applied ✓' : AppStrings.apply,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Price Breakdown
                      _PriceRow(label: AppStrings.subtotal, value: currency.format(subtotal)),
                      const SizedBox(height: 6),
                      _PriceRow(
                        label: AppStrings.deliveryFee,
                        value: delivery == 0 ? 'FREE 🎉' : currency.format(delivery),
                        valueColor: delivery == 0 ? AppColors.success : null,
                      ),
                      const SizedBox(height: 6),
                      _PriceRow(label: AppStrings.tax, value: currency.format(tax)),
                      if (discount > 0) ...[
                        const SizedBox(height: 6),
                        _PriceRow(
                          label: 'Discount (${ref.watch(appliedPromoCodeProvider) ?? ''})',
                          value: '- ${currency.format(discount)}',
                          valueColor: AppColors.success,
                        ),
                      ],
                      const Divider(color: AppColors.darkBorder, height: 20),
                      _PriceRow(
                        label: AppStrings.total,
                        value: currency.format(total),
                        isBold: true,
                      ),
                      const SizedBox(height: AppSizes.md),

                      GradientButton(
                        label: AppStrings.proceedToCheckout,
                        onPressed: () => context.push(AppRoutes.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItemModel item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '৳');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrls.first,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerLoader(width: 80, height: 80, borderRadius: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                if (item.selectedSize != null || item.selectedColor != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${item.selectedSize != null ? 'Size: ${item.selectedSize}' : ''} ${item.selectedColor != null ? '| ${item.selectedColor}' : ''}',
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      currency.format(item.product.price),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    const Spacer(),
                    // Quantity Controls
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => ref.read(cartProvider.notifier).decrementQty(item.product.id, size: item.selectedSize),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => ref.read(cartProvider.notifier).incrementQty(item.product.id, size: item.selectedSize),
                      isAdd: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => ref.read(cartProvider.notifier).removeItem(item.product.id, size: item.selectedSize),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: AppColors.error, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;

  const _QtyButton({required this.icon, required this.onTap, this.isAdd = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          gradient: isAdd
              ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])
              : null,
          color: isAdd ? null : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: isAdd ? null : Border.all(color: AppColors.darkBorder),
        ),
        child: Icon(icon, size: 16, color: isAdd ? Colors.white : AppColors.textPrimary),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isBold ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: const Icon(Iconsax.shopping_cart, color: AppColors.textMuted, size: 46),
          ),
          const SizedBox(height: AppSizes.lg),
          const Text(AppStrings.emptyCart, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text(AppStrings.emptyCartSub, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: AppSizes.lg),
          GestureDetector(
            onTap: () => context.go('/explore'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Start Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
