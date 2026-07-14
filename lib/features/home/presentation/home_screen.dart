import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax/iconsax.dart';
import '../data/repositories/home_repository.dart';
import '../data/models/home_models.dart';
import '../../products/domain/providers/product_provider.dart';
import '../../auth/domain/providers/auth_provider.dart';
import '../../cart/domain/providers/cart_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';

import '../../../../core/providers/app_mode_provider.dart';
import '../../pharmacy/presentation/pharmacy_home_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final cartCount = ref.watch(cartCountProvider);
    final appMode = ref.watch(appModeProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ───────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: context.bgColor,
            elevation: 0,
            toolbarHeight: 70,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                children: [
                  // Menu Bar Icon
                  GestureDetector(
                    onTap: () {
                      // Open drawer or handle menu action
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.grid_view_rounded, color: Colors.indigo, size: 20),
                    ),
                  ),
                  const Spacer(),
                  // Shop Selection Icon
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.shopSelection),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.storefront_outlined, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notifications),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      ),
                      child: const Icon(Iconsax.notification, color: Colors.orange, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  // Cart Icon with badge
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.cart),
                    child: Stack(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal.withOpacity(0.2)),
                          ),
                          child: const Icon(Iconsax.shopping_cart, color: Colors.teal, size: 20),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: context.bgColor, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  cartCount > 9 ? '9+' : cartCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Conditional Content ──────────────────────────────────
          if (appMode == AppMode.pharmacy)
            const SliverFillRemaining(
              child: PharmacyHomeView(),
            )
          else
            ..._buildLifestyleSlivers(context),
        ],
      ),
    );
  }

  List<Widget> _buildLifestyleSlivers(BuildContext context) {
    return [
          // ── Search Bar ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.explore),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(Iconsax.search_normal, color: context.textMutedColor, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppStrings.searchHint,
                          style: TextStyle(color: context.textMutedColor, fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Iconsax.setting_4, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Banners ───────────────────────────────────────────
          SliverToBoxAdapter(child: _BannerCarousel()),

          // ── Categories ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.categories,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.explore),
                    child: const Text(
                      AppStrings.seeAll,
                      style: TextStyle(fontSize: 13, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _CategoriesRow()),

          // ── Trending ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.trending,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.explore),
                    child: const Text(AppStrings.seeAll, style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _TrendingProducts()),

          // ── Flash Sale ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FlashSaleHeader(),
          ),
          SliverToBoxAdapter(child: _FlashSaleProducts()),

          // ── New Arrivals Grid ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.newArrivals,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.explore),
                    child: const Text(AppStrings.seeAll, style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),

          // New Arrivals Grid (SliverGrid for performance)
          _NewArrivalsGrid(),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
    ];
  }
}

// ── Banner Carousel ─────────────────────────────────────────────────────────
class _BannerCarousel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<_BannerCarousel> {
  final _pageController = PageController(viewportFraction: 0.92);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(bannersProvider);

    return bannersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: ShimmerBanner(),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (banners) => Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return _BannerCard(banner: banner);
              },
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          SmoothPageIndicator(
            controller: _pageController,
            count: banners.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: context.borderColor,
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: banner.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerLoader(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 20,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Text content
            Positioned(
              left: 20,
              bottom: 20,
              right: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      banner.ctaText,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Categories Row ──────────────────────────────────────────────────────────
class _CategoriesRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return SizedBox(
      height: 100,
      child: categoriesAsync.when(
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: 6,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: ShimmerLoader(width: 70, height: 90, borderRadius: 14),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (categories) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () => context.go('${AppRoutes.explore}?category=${cat.name}'),
              child: Container(
                width: 72,
                margin: const EdgeInsets.only(right: AppSizes.sm),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Center(
                        child: Text(cat.emoji, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: context.textSecondaryColor),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Trending Products ───────────────────────────────────────────────────────
class _TrendingProducts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingProductsProvider);

    return SizedBox(
      height: 260,
      child: trendingAsync.when(
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: AppSizes.sm),
            child: SizedBox(width: 160, child: ShimmerProductCard()),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (products) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return SizedBox(
              width: 165,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSizes.sm),
                child: ProductCard(
                  product: product,
                  onTap: () => context.push('/products/${product.id}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Flash Sale Header ───────────────────────────────────────────────────────
class _FlashSaleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.flashSaleStart, AppColors.flashSaleEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.flashSale,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Deals end soon!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _CountdownTimer(),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  int _seconds = 3600;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _seconds = _seconds > 0 ? _seconds - 1 : 3600);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = (_seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$h:$m:$s',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// ── Flash Sale Products ─────────────────────────────────────────────────────
class _FlashSaleProducts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashAsync = ref.watch(flashSaleProductsProvider);

    return SizedBox(
      height: 260,
      child: flashAsync.when(
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: 3,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: AppSizes.sm),
            child: SizedBox(width: 160, child: ShimmerProductCard()),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (products) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return SizedBox(
              width: 165,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSizes.sm),
                child: ProductCard(
                  product: product,
                  onTap: () => context.push('/products/${product.id}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── New Arrivals SliverGrid ─────────────────────────────────────────────────
class _NewArrivalsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrivalsAsync = ref.watch(newArrivalsProvider);

    return arrivalsAsync.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        sliver: SliverGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
          children: const [
            ShimmerProductCard(),
            ShimmerProductCard(),
            ShimmerProductCard(),
            ShimmerProductCard(),
          ],
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (products) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        sliver: SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/products/${product.id}'),
            );
          },
        ),
      ),
    );
  }
}
