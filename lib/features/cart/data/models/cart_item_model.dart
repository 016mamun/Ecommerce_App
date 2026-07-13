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

  @override
  List<Object?> get props => [product.id, selectedSize, selectedColor];
}
