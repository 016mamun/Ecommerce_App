import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../data/models/medicine_model.dart';
import '../domain/providers/medicine_provider.dart';
import '../presentation/prescription_upload_sheet.dart';
import '../../cart/domain/providers/cart_provider.dart';
import '../../products/data/models/product_model.dart';
import '../../wishlist/domain/providers/wishlist_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../core/widgets/shimmer_loader.dart';

class MedicineDetailsView extends ConsumerStatefulWidget {
  final String medicineId;

  const MedicineDetailsView({super.key, required this.medicineId});

  @override
  ConsumerState<MedicineDetailsView> createState() =>
      _MedicineDetailsViewState();
}

class _MedicineDetailsViewState extends ConsumerState<MedicineDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _addedToCart = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineAsync =
        ref.watch(medicineDetailProvider(widget.medicineId));

    return Scaffold(
      backgroundColor: context.bgColor,
      body: medicineAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
              color: AppColors.pharmacyPrimary),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (medicine) {
          if (medicine == null) {
            return const Center(child: Text('Medicine not found'));
          }
          return _MedicineDetailContent(
            medicine: medicine,
            tabController: _tabController,
            addedToCart: _addedToCart,
            onAddToCart: () => setState(() {
              _addedToCart = true;
              _doAddToCart(medicine);
            }),
          );
        },
      ),
    );
  }

  void _doAddToCart(MedicineModel medicine) {
    final product = ProductModel(
      id: medicine.id,
      title: '${medicine.brandName} ${medicine.strength}',
      description: medicine.genericName,
      price: medicine.price,
      originalPrice: medicine.originalPrice,
      discountPercent: medicine.discountPercent,
      imageUrls: [medicine.imageUrl],
      category: 'Pharmacy',
      rating: medicine.rating,
      reviewCount: medicine.reviewCount,
      stock: medicine.stock,
      brand: medicine.manufacturer,
    );
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${medicine.brandName} added to cart'),
        backgroundColor: AppColors.pharmacyPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

// ── Detail Content ────────────────────────────────────────────────────────────
class _MedicineDetailContent extends ConsumerWidget {
  final MedicineModel medicine;
  final TabController tabController;
  final bool addedToCart;
  final VoidCallback onAddToCart;

  const _MedicineDetailContent({
    required this.medicine,
    required this.tabController,
    required this.addedToCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistIds = ref.watch(wishlistProvider);
    final isWishlisted = wishlistIds.contains(medicine.id);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Hero Image App Bar ─────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.pharmacyDark,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () =>
                  ref.read(wishlistProvider.notifier).toggle(medicine.id),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (c, a) =>
                        ScaleTransition(scale: a, child: c),
                    child: Icon(
                      isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                      key: ValueKey(isWishlisted),
                      color: isWishlisted
                          ? AppColors.rxBadge
                          : Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: medicine.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppColors.pharmacyLight,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.pharmacyLight,
                    child: const Icon(Iconsax.health,
                        size: 80, color: AppColors.pharmacyPrimary),
                  ),
                ),
                // Gradient overlay for readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                // Overlay badges + name
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (medicine.isRxRequired)
                            _OverlayBadge(
                                label: 'Rx Required',
                                color: AppColors.rxBadge),
                          const SizedBox(width: 6),
                          _OverlayBadge(
                            label: medicine.category.label,
                            color: _categoryColor(medicine.category),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        medicine.brandName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${medicine.genericName} · ${medicine.strength}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Price + Rating row ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: context.surfaceColor,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '৳${medicine.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pharmacyPrimary,
                          ),
                        ),
                        if (medicine.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '৳${medicine.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: context.textMutedColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.pharmacyPrimary
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${medicine.discountPercent}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pharmacyPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      medicine.manufacturer,
                      style: TextStyle(
                          fontSize: 12, color: context.textMutedColor),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          medicine.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${medicine.reviewCount} reviews',
                      style: TextStyle(
                          fontSize: 11, color: context.textMutedColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Rx warning banner (if applicable) ─────────────────────────────
        if (medicine.isRxRequired)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.rxBadge.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.rxBadge.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.warning_2,
                      color: AppColors.rxBadge, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.prescriptionNote,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.rxBadge.withOpacity(0.85)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _showPrescriptionSheet(context),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.rxBadge,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── Tab Bar ────────────────────────────────────────────────────────
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(
            TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: AppColors.pharmacyPrimary,
              indicatorWeight: 3,
              labelColor: AppColors.pharmacyPrimary,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700),
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Indications'),
                Tab(text: 'Side Effects'),
                Tab(text: 'Warnings'),
                Tab(text: 'Dosage'),
              ],
            ),
          ),
        ),

        // ── Tab View Content ───────────────────────────────────────────────
        SliverFillRemaining(
          child: TabBarView(
            controller: tabController,
            children: [
              _OverviewTab(medicine: medicine),
              _ListTab(
                  items: medicine.indications, icon: Iconsax.tick_circle),
              _ListTab(
                  items: medicine.sideEffects,
                  icon: Iconsax.warning_2,
                  iconColor: AppColors.warning),
              _ListTab(
                  items: medicine.warnings,
                  icon: Iconsax.shield_cross,
                  iconColor: AppColors.rxBadge),
              _ListTab(
                  items: medicine.dosageGuidelines,
                  icon: Iconsax.clock,
                  iconColor: AppColors.pharmacySecondary),
            ],
          ),
        ),
      ],
    );
  }

  void _showPrescriptionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrescriptionUploadSheet(),
    );
  }

  static Color _categoryColor(MedicineCategory cat) {
    switch (cat) {
      case MedicineCategory.otc:
        return AppColors.otcBadge;
      case MedicineCategory.prescription:
        return AppColors.rxBadge;
      case MedicineCategory.herbal:
        return AppColors.herbalBadge;
      case MedicineCategory.personalCare:
        return AppColors.personalCareBadge;
    }
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final MedicineModel medicine;

  const _OverviewTab({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Generic Name', medicine.genericName),
      ('Brand Name', medicine.brandName),
      ('Strength', medicine.strength),
      ('Category', '${medicine.category.emoji} ${medicine.category.label}'),
      ('Manufacturer', medicine.manufacturer),
      ('Rx Required', medicine.isRxRequired ? 'Yes ⚠️' : 'No ✅'),
      ('Availability', medicine.isAvailable ? 'In Stock ✅' : 'Out of Stock ❌'),
      ('Stock', '${medicine.stock} units'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...rows.map((row) => _InfoRow(label: row.$1, value: row.$2)),
        const SizedBox(height: 80), // Bottom padding for FAB
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  color: context.textMutedColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── List Tab (Indications, Side Effects, Warnings, Dosage) ────────────────────
class _ListTab extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color? iconColor;

  const _ListTab({
    required this.items,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No information available.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const SizedBox(height: 80);
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  size: 18,
                  color:
                      iconColor ?? AppColors.pharmacyPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textPrimaryColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Overlay Badge ─────────────────────────────────────────────────────────────
class _OverlayBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _OverlayBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ── Tab Bar Persistent Header Delegate ────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.surfaceColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
