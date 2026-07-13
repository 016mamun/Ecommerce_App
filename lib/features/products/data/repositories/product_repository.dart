import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> getTrendingProducts();
  Future<List<ProductModel>> getFlashSaleProducts();
  Future<List<ProductModel>> getNewArrivals();
  Future<List<ProductModel>> searchProducts(String query);
}

class MockProductRepository implements ProductRepository {
  static final _allProducts = <ProductModel>[
    // ── Electronics ────────────────────────────────────────────
    ProductModel(
      id: 'p001',
      title: 'Samsung Galaxy S24 Ultra 256GB',
      description: 'Experience the pinnacle of Samsung innovation with the Galaxy S24 Ultra. Features a 6.8" Dynamic AMOLED 2X display, 200MP camera, built-in S Pen, and Snapdragon 8 Gen 3 processor. Perfect for power users and creators.',
      price: 124999,
      originalPrice: 134999,
      discountPercent: 7,
      imageUrls: [
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=600&q=80',
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600&q=80',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80',
      ],
      category: 'Electronics',
      rating: 4.8,
      reviewCount: 2345,
      stock: 12,
      colors: ['Titanium Black', 'Titanium Gray', 'Titanium Violet'],
      brand: 'Samsung',
      isTrending: true,
    ),
    ProductModel(
      id: 'p002',
      title: 'Apple AirPods Pro (2nd Gen)',
      description: 'The AirPods Pro deliver extraordinary noise cancellation, Adaptive Audio that seamlessly transitions between Active Noise Cancellation and Transparency. H2 chip, up to 6 hours battery life.',
      price: 24999,
      originalPrice: 29999,
      discountPercent: 17,
      imageUrls: [
        'https://images.unsplash.com/photo-1588423771073-b8903fead714?w=600&q=80',
        'https://images.unsplash.com/photo-1606741965509-717d26940469?w=600&q=80',
      ],
      category: 'Electronics',
      rating: 4.9,
      reviewCount: 5621,
      stock: 45,
      colors: ['White'],
      brand: 'Apple',
      isTrending: true,
      isFlashSale: true,
    ),
    ProductModel(
      id: 'p003',
      title: 'Sony WH-1000XM5 Headphones',
      description: 'Industry-leading noise cancellation with 8 microphones and two processors. Up to 30 hours battery, quick charging (3 min charge = 3 hours playback). Premium comfort for all-day listening.',
      price: 29999,
      originalPrice: 38000,
      discountPercent: 21,
      imageUrls: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&q=80',
      ],
      category: 'Electronics',
      rating: 4.7,
      reviewCount: 3210,
      stock: 8,
      colors: ['Midnight Black', 'Platinum Silver'],
      brand: 'Sony',
      isFlashSale: true,
    ),
    ProductModel(
      id: 'p004',
      title: 'iPad Air M2 11" 256GB WiFi',
      description: 'Supercharged by the Apple M2 chip. Liquid Retina display, Apple Pencil and Magic Keyboard support. All-day battery life up to 10 hours. Available in 5 stunning colors.',
      price: 79999,
      originalPrice: 85999,
      discountPercent: 7,
      imageUrls: [
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&q=80',
        'https://images.unsplash.com/photo-1589739900266-43b2843f4c12?w=600&q=80',
      ],
      category: 'Electronics',
      rating: 4.8,
      reviewCount: 1890,
      stock: 20,
      colors: ['Blue', 'Purple', 'Starlight', 'Space Gray', 'Pink'],
      brand: 'Apple',
      isTrending: true,
    ),
    ProductModel(
      id: 'p005',
      title: 'MacBook Air 13" M3 Chip 8GB/256GB',
      description: 'Supercharged by the new M3 chip, MacBook Air is the world\'s best consumer laptop. Up to 18 hours battery, MagSafe charging, 8-core CPU, and a stunning Liquid Retina display.',
      price: 139999,
      originalPrice: 149999,
      discountPercent: 7,
      imageUrls: [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80',
        'https://images.unsplash.com/photo-1611186871525-48ef0eeaa69e?w=600&q=80',
      ],
      category: 'Electronics',
      rating: 4.9,
      reviewCount: 4102,
      stock: 6,
      colors: ['Midnight', 'Starlight', 'Space Gray', 'Silver'],
      brand: 'Apple',
      isNewArrival: true,
    ),

    // ── Fashion Men ────────────────────────────────────────────
    ProductModel(
      id: 'p006',
      title: 'Men\'s Premium Slim Fit Oxford Shirt',
      description: 'Crafted from 100% premium Egyptian cotton, this slim-fit shirt offers a sharp silhouette perfect for office or casual outings. Wrinkle-resistant fabric, 6-button placket.',
      price: 1850,
      originalPrice: 2500,
      discountPercent: 26,
      imageUrls: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&q=80',
        'https://images.unsplash.com/photo-1604257523850-29a7f888f10d?w=600&q=80',
      ],
      category: 'Fashion',
      rating: 4.5,
      reviewCount: 876,
      stock: 50,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['White', 'Light Blue', 'Navy', 'Olive'],
      brand: 'StyleCraft',
      isTrending: true,
    ),
    ProductModel(
      id: 'p007',
      title: 'Men\'s Stretch Chino Pants - Slim Fit',
      description: 'Our best-selling chinos now with 4-way stretch technology for unmatched comfort. Features a modern slim fit, zip-fly, and 5-pocket design. Perfect for both work and weekend.',
      price: 2299,
      originalPrice: 3200,
      discountPercent: 28,
      imageUrls: [
        'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=600&q=80',
        'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&q=80',
      ],
      category: 'Fashion',
      rating: 4.4,
      reviewCount: 634,
      stock: 30,
      sizes: ['28', '30', '32', '34', '36', '38'],
      colors: ['Khaki', 'Navy', 'Olive', 'Gray'],
      brand: 'DenimHouse',
      isFlashSale: true,
    ),

    // ── Fashion Women ──────────────────────────────────────────
    ProductModel(
      id: 'p008',
      title: 'Women\'s Floral Maxi Dress',
      description: 'A beautiful flowing maxi dress featuring an intricate floral print. Made from a lightweight viscose blend, perfect for summer days. Features adjustable straps and side pockets.',
      price: 1999,
      originalPrice: 3000,
      discountPercent: 33,
      imageUrls: [
        'https://images.unsplash.com/photo-1618932260643-eee4a2f652a6?w=600&q=80',
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600&q=80',
      ],
      category: 'Fashion',
      rating: 4.6,
      reviewCount: 1204,
      stock: 25,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Blue Floral', 'Pink Floral', 'Yellow Floral'],
      brand: 'FabricFantasy',
      isTrending: true,
    ),
    ProductModel(
      id: 'p009',
      title: 'Women\'s High-Waist Yoga Leggings',
      description: 'Our ultra-soft, high-performance leggings are made from a 4-way stretch nylon-spandex blend. Moisture-wicking, squat-proof with a hidden waistband pocket.',
      price: 1299,
      originalPrice: 1800,
      discountPercent: 28,
      imageUrls: [
        'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=600&q=80',
        'https://images.unsplash.com/photo-1591195853828-11db59a44f43?w=600&q=80',
      ],
      category: 'Fashion',
      rating: 4.7,
      reviewCount: 2890,
      stock: 60,
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Black', 'Navy', 'Charcoal', 'Burgundy', 'Forest Green'],
      brand: 'ActiveWear',
      isFlashSale: true,
      isNewArrival: true,
    ),

    // ── Footwear ───────────────────────────────────────────────
    ProductModel(
      id: 'p010',
      title: 'Nike Air Max 270 React Sneakers',
      description: 'Experience maximum comfort with the Nike Air Max 270 React. Features a React foam midsole for a responsive ride and a large Air unit in the heel for unbeatable cushioning.',
      price: 12999,
      originalPrice: 15000,
      discountPercent: 13,
      imageUrls: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600&q=80',
      ],
      category: 'Footwear',
      rating: 4.8,
      reviewCount: 3456,
      stock: 18,
      sizes: ['39', '40', '41', '42', '43', '44', '45'],
      colors: ['Black/White', 'White/Blue', 'Red/Black'],
      brand: 'Nike',
      isTrending: true,
    ),
    ProductModel(
      id: 'p011',
      title: 'Adidas Ultraboost 23 Running Shoes',
      description: 'Engineered for runners who demand peak performance. BOOST midsole technology returns energy with every stride. PRIMEKNIT+ upper hugs your foot for a sock-like fit.',
      price: 14500,
      originalPrice: 17000,
      discountPercent: 15,
      imageUrls: [
        'https://images.unsplash.com/photo-1608667508764-33cf0726b13a?w=600&q=80',
        'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=600&q=80',
      ],
      category: 'Footwear',
      rating: 4.7,
      reviewCount: 2100,
      stock: 14,
      sizes: ['38', '39', '40', '41', '42', '43', '44', '45'],
      colors: ['Core Black', 'Cloud White', 'Navy Blue'],
      brand: 'Adidas',
      isFlashSale: true,
    ),

    // ── Beauty & Personal Care ─────────────────────────────────
    ProductModel(
      id: 'p012',
      title: 'Charlotte Tilbury Pillow Talk Lipstick',
      description: 'The cult-classic Pillow Talk shade — a warm rose-pink — in Charlotte\'s legendary Matte Revolution formula. Gives lips a petal-soft, weightless feel with intense color payoff.',
      price: 3200,
      originalPrice: 3800,
      discountPercent: 16,
      imageUrls: [
        'https://images.unsplash.com/photo-1586495777744-4e6232bf2ebb?w=600&q=80',
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=600&q=80',
      ],
      category: 'Beauty',
      rating: 4.9,
      reviewCount: 5412,
      stock: 35,
      colors: ['Pillow Talk', 'Walk of No Shame', 'Bond Girl'],
      brand: 'Charlotte Tilbury',
      isTrending: true,
    ),
    ProductModel(
      id: 'p013',
      title: 'The Ordinary Niacinamide 10% + Zinc 1%',
      description: 'A high-strength vitamin and mineral blemish formula. Reduces appearance of blemishes and congestion. Balances visible aspects of sebum activity. Suitable for all skin types.',
      price: 899,
      originalPrice: 1200,
      discountPercent: 25,
      imageUrls: [
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
        'https://images.unsplash.com/photo-1611080625539-c0a56bb2eb68?w=600&q=80',
      ],
      category: 'Beauty',
      rating: 4.7,
      reviewCount: 8921,
      stock: 75,
      brand: 'The Ordinary',
      isFlashSale: true,
      isNewArrival: true,
    ),

    // ── Home & Living ──────────────────────────────────────────
    ProductModel(
      id: 'p014',
      title: 'Minimalist Ceramic Vase Set of 3',
      description: 'A stunning set of three hand-crafted ceramic vases in varying heights, perfect for dried flowers or as standalone decor. Matte white finish with subtle texture.',
      price: 2499,
      originalPrice: 3500,
      discountPercent: 29,
      imageUrls: [
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=600&q=80',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=600&q=80',
      ],
      category: 'Home',
      rating: 4.6,
      reviewCount: 342,
      stock: 22,
      colors: ['Matte White', 'Sage Green', 'Terracotta'],
      brand: 'HomeEssentials',
      isNewArrival: true,
    ),
    ProductModel(
      id: 'p015',
      title: 'Premium Scented Soy Candle - Vanilla & Sandalwood',
      description: 'Hand-poured in small batches using 100% natural soy wax. Lead-free cotton wick. Burns cleanly for up to 60 hours. Luxurious vanilla and sandalwood fragrance.',
      price: 1499,
      originalPrice: 1800,
      discountPercent: 17,
      imageUrls: [
        'https://images.unsplash.com/photo-1603905993716-2ed1b7b3b82c?w=600&q=80',
        'https://images.unsplash.com/photo-1608181831718-d9e2793da384?w=600&q=80',
      ],
      category: 'Home',
      rating: 4.8,
      reviewCount: 789,
      stock: 40,
      colors: ['Vanilla & Sandalwood', 'Lavender & Eucalyptus', 'Cedar & Amber'],
      brand: 'LuxeCandles',
      isTrending: true,
    ),

    // ── Sports ─────────────────────────────────────────────────
    ProductModel(
      id: 'p016',
      title: 'Yonex Nanoflare 700 Badminton Racket',
      description: 'The Nanoflare 700 features NANOMESH + CARBON NANOTUBE for maximum control and feel. Light and fast, ideal for competitive players. Isometric head shape for expanded sweet spot.',
      price: 8500,
      originalPrice: 11000,
      discountPercent: 23,
      imageUrls: [
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=600&q=80',
        'https://images.unsplash.com/photo-1624278232028-8bf40dc1f70c?w=600&q=80',
      ],
      category: 'Sports',
      rating: 4.7,
      reviewCount: 567,
      stock: 10,
      brand: 'Yonex',
      isFlashSale: true,
    ),
    ProductModel(
      id: 'p017',
      title: 'Premium Yoga Mat 6mm Extra Thick',
      description: 'Eco-friendly TPE material, non-slip surface on both sides. Extra thickness provides joint support. Includes carry strap. Lightweight at only 1.5kg.',
      price: 1999,
      originalPrice: 2800,
      discountPercent: 29,
      imageUrls: [
        'https://images.unsplash.com/photo-1601925228964-f8c15ddb5ee3?w=600&q=80',
        'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80',
      ],
      category: 'Sports',
      rating: 4.5,
      reviewCount: 1234,
      stock: 55,
      colors: ['Purple', 'Blue', 'Green', 'Black', 'Pink'],
      brand: 'FitLife',
      isNewArrival: true,
    ),

    // ── Accessories ────────────────────────────────────────────
    ProductModel(
      id: 'p018',
      title: 'Fossil Townsman Men\'s Chronograph Watch',
      description: 'Sophisticated chronograph watch with a 44mm stainless steel case, genuine leather strap, and mineral glass crystal. Water-resistant up to 50 meters. Quartz movement.',
      price: 14999,
      originalPrice: 19000,
      discountPercent: 21,
      imageUrls: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80',
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80',
      ],
      category: 'Accessories',
      rating: 4.6,
      reviewCount: 892,
      stock: 7,
      colors: ['Brown Leather', 'Black Leather', 'Steel Mesh'],
      brand: 'Fossil',
      isTrending: true,
    ),
    ProductModel(
      id: 'p019',
      title: 'Leather Bifold Wallet - RFID Blocking',
      description: 'Slim genuine leather wallet with RFID-blocking technology to protect your cards. 6 card slots, 2 bill compartments, ID window. Comes in a premium gift box.',
      price: 1299,
      originalPrice: 1800,
      discountPercent: 28,
      imageUrls: [
        'https://images.unsplash.com/photo-1627123424574-724758594785?w=600&q=80',
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&q=80',
      ],
      category: 'Accessories',
      rating: 4.4,
      reviewCount: 1567,
      stock: 80,
      colors: ['Brown', 'Black', 'Tan', 'Navy'],
      brand: 'LeatherCraft',
      isFlashSale: true,
    ),
    ProductModel(
      id: 'p020',
      title: 'Ray-Ban Aviator Classic Sunglasses',
      description: 'The timeless Aviator. Large teardrop lenses, thin metal frame, adjustable nose pads. 100% UV400 protection. Available in various lens tints and frame finishes.',
      price: 12500,
      originalPrice: 15000,
      discountPercent: 17,
      imageUrls: [
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&q=80',
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&q=80',
      ],
      category: 'Accessories',
      rating: 4.8,
      reviewCount: 3201,
      stock: 25,
      colors: ['Gold/G-15', 'Silver/Blue', 'Gold/Brown'],
      brand: 'Ray-Ban',
      isTrending: true,
      isNewArrival: true,
    ),
  ];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _allProducts;
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (category.isEmpty) return _allProducts;
    return _allProducts.where((p) => p.category == category).toList();
  }

  @override
  Future<List<ProductModel>> getTrendingProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allProducts.where((p) => p.isTrending).toList();
  }

  @override
  Future<List<ProductModel>> getFlashSaleProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allProducts.where((p) => p.isFlashSale).toList();
  }

  @override
  Future<List<ProductModel>> getNewArrivals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allProducts.where((p) => p.isNewArrival).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = query.toLowerCase();
    return _allProducts
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q))
        .toList();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return MockProductRepository();
});
