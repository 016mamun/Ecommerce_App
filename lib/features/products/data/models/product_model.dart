import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> sizes;
  final List<String> colors;
  final String brand;
  final bool isTrending;
  final bool isFlashSale;
  final bool isNewArrival;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    this.sizes = const [],
    this.colors = const [],
    required this.brand,
    this.isTrending = false,
    this.isFlashSale = false,
    this.isNewArrival = false,
  });

  bool get isOutOfStock => stock == 0;
  bool get isLowStock => stock > 0 && stock <= 5;

  @override
  List<Object?> get props => [id];
}
