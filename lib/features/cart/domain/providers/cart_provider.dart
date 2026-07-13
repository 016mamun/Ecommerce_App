import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item_model.dart';
import '../../../products/data/models/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addItem(ProductModel product, {String? size, String? color}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItemModel>.from(state);
      final existing = updated[existingIndex];
      updated[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
      state = updated;
    } else {
      state = [
        ...state,
        CartItemModel(
          product: product,
          quantity: 1,
          selectedSize: size,
          selectedColor: color,
        ),
      ];
    }
  }

  void removeItem(String productId, {String? size}) {
    state = state
        .where((item) => !(item.product.id == productId && item.selectedSize == size))
        .toList();
  }

  void incrementQty(String productId, {String? size}) {
    state = state.map((item) {
      if (item.product.id == productId && item.selectedSize == size) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decrementQty(String productId, {String? size}) {
    final item = state.firstWhere(
      (i) => i.product.id == productId && i.selectedSize == size,
    );
    if (item.quantity <= 1) {
      removeItem(productId, size: size);
    } else {
      state = state.map((i) {
        if (i.product.id == productId && i.selectedSize == size) {
          return i.copyWith(quantity: i.quantity - 1);
        }
        return i;
      }).toList();
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});

// Derived providers — only these rebuild when specific values change
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0.0, (sum, item) => sum + item.itemTotal);
});

final cartDeliveryFeeProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  if (subtotal == 0) return 0;
  return subtotal >= 3000 ? 0 : 80; // Free delivery above ৳3000
});

final cartTaxProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  return subtotal * 0.05; // 5% VAT
});

final promoDiscountProvider = StateProvider<double>((ref) => 0.0);
final appliedPromoCodeProvider = StateProvider<String?>((ref) => null);

final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final delivery = ref.watch(cartDeliveryFeeProvider);
  final tax = ref.watch(cartTaxProvider);
  final discount = ref.watch(promoDiscountProvider);
  return subtotal + delivery + tax - discount;
});

// Promo Code logic
final Map<String, double> _promoCodes = {
  'SAVE10': 0.10,
  'FLAT200': 0.0, // Special flat discount handled separately
  'WELCOME20': 0.20,
  'SHOPNEST15': 0.15,
};

String? applyPromoCode(WidgetRef ref, String code) {
  final upperCode = code.toUpperCase().trim();

  if (upperCode == 'FLAT200') {
    ref.read(promoDiscountProvider.notifier).state = 200;
    ref.read(appliedPromoCodeProvider.notifier).state = upperCode;
    return null;
  }

  final discountPct = _promoCodes[upperCode];
  if (discountPct == null) return 'Invalid promo code';

  final subtotal = ref.read(cartSubtotalProvider);
  ref.read(promoDiscountProvider.notifier).state = subtotal * discountPct;
  ref.read(appliedPromoCodeProvider.notifier).state = upperCode;
  return null; // success
}
