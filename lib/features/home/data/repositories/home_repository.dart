import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_models.dart';

class MockHomeRepository {
  Future<List<BannerModel>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return const [
      BannerModel(
        id: 'b001',
        imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=85',
        title: 'Summer Sale 🔥',
        subtitle: 'Up to 50% off on Electronics',
        ctaText: 'Shop Now',
        routePath: '/explore?category=Electronics',
        backgroundColor: '#6C63FF',
      ),
      BannerModel(
        id: 'b002',
        imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=85',
        title: 'Fashion Week ✨',
        subtitle: 'New arrivals every day',
        ctaText: 'Explore',
        routePath: '/explore?category=Fashion',
        backgroundColor: '#FF6584',
      ),
      BannerModel(
        id: 'b003',
        imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&q=85',
        title: 'Flash Sale ⚡',
        subtitle: 'Limited time deals on Sports & Beauty',
        ctaText: 'Grab Deal',
        routePath: '/explore',
        backgroundColor: '#43E97B',
      ),
      BannerModel(
        id: 'b004',
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&q=85',
        title: 'Free Delivery 🚚',
        subtitle: 'On orders above ৳3,000',
        ctaText: 'Order Now',
        routePath: '/home',
        backgroundColor: '#667EEA',
      ),
    ];
  }

  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      CategoryModel(
        id: 'c001',
        name: 'Electronics',
        imageUrl: 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200&q=80',
        emoji: '📱',
        productCount: 156,
      ),
      CategoryModel(
        id: 'c002',
        name: 'Fashion',
        imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=200&q=80',
        emoji: '👗',
        productCount: 342,
      ),
      CategoryModel(
        id: 'c003',
        name: 'Footwear',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200&q=80',
        emoji: '👟',
        productCount: 89,
      ),
      CategoryModel(
        id: 'c004',
        name: 'Beauty',
        imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200&q=80',
        emoji: '💄',
        productCount: 215,
      ),
      CategoryModel(
        id: 'c005',
        name: 'Home',
        imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200&q=80',
        emoji: '🏠',
        productCount: 127,
      ),
      CategoryModel(
        id: 'c006',
        name: 'Sports',
        imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=200&q=80',
        emoji: '⚽',
        productCount: 98,
      ),
      CategoryModel(
        id: 'c007',
        name: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=200&q=80',
        emoji: '⌚',
        productCount: 175,
      ),
      CategoryModel(
        id: 'c008',
        name: 'Books',
        imageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=200&q=80',
        emoji: '📚',
        productCount: 462,
      ),
    ];
  }
}

final homeRepositoryProvider = Provider<MockHomeRepository>((ref) => MockHomeRepository());

final bannersProvider = FutureProvider<List<BannerModel>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getBanners();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getCategories();
});
