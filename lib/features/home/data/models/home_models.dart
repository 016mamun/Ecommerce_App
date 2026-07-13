class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String ctaText;
  final String? routePath;
  final String backgroundColor;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    this.routePath,
    this.backgroundColor = '#6C63FF',
  });
}

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String emoji;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.emoji,
    required this.productCount,
  });
}
