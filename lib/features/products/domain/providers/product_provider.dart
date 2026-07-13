import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

// ── Filter State ──────────────────────────────────────────────────────────────
class ProductFilter {
  final String category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? brand;
  final String? size;
  final String? color;
  final String sortBy; // 'popularity', 'price_asc', 'price_desc', 'rating', 'newest'

  const ProductFilter({
    this.category = '',
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.brand,
    this.size,
    this.color,
    this.sortBy = 'popularity',
  });

  ProductFilter copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? brand,
    String? size,
    String? color,
    String? sortBy,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      brand: brand ?? this.brand,
      size: size ?? this.size,
      color: color ?? this.color,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final productFilterProvider = StateProvider<ProductFilter>((ref) => const ProductFilter());

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final trendingProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getTrendingProducts();
});

final flashSaleProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFlashSaleProducts();
});

final newArrivalsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getNewArrivals();
});

final productDetailProvider = FutureProvider.family<ProductModel?, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(id);
});

final filteredProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final filter = ref.watch(productFilterProvider);
  final repo = ref.watch(productRepositoryProvider);

  List<ProductModel> products;
  if (filter.category.isNotEmpty) {
    products = await repo.getProductsByCategory(filter.category);
  } else {
    products = await repo.getAllProducts();
  }

  // Apply filters
  if (filter.minPrice != null) {
    products = products.where((p) => p.price >= filter.minPrice!).toList();
  }
  if (filter.maxPrice != null) {
    products = products.where((p) => p.price <= filter.maxPrice!).toList();
  }
  if (filter.minRating != null) {
    products = products.where((p) => p.rating >= filter.minRating!).toList();
  }
  if (filter.brand != null && filter.brand!.isNotEmpty) {
    products = products.where((p) => p.brand == filter.brand).toList();
  }
  if (filter.size != null && filter.size!.isNotEmpty) {
    products = products.where((p) => p.sizes.contains(filter.size)).toList();
  }

  // Sorting
  switch (filter.sortBy) {
    case 'price_asc':
      products.sort((a, b) => a.price.compareTo(b.price));
      break;
    case 'price_desc':
      products.sort((a, b) => b.price.compareTo(a.price));
      break;
    case 'rating':
      products.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    default:
      break;
  }

  return products;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(productRepositoryProvider);
  return repo.searchProducts(query);
});
