import 'package:equatable/equatable.dart';
import '../../../products/data/models/product_model.dart';

class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  CartItemModel copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  double get itemTotal => product.price * quantity;

  bool get isRxRequired => product.category == 'Pharmacy' && (product.id.contains('rx') || product.id.startsWith('med_')); // Since we don't have isRxRequired on ProductModel, we'll infer it from the fact that it's a pharmacy item, or we can just update ProductModel. Let's just update ProductModel directly, or use a getter.
  // Actually, we mapped isRxRequired via the product model adapter in MedicineCard. Wait, we didn't add it to ProductModel.
  // Let's add isRxRequired to ProductModel first.

  @override
  List<Object?> get props => [product.id, selectedSize, selectedColor];
}
