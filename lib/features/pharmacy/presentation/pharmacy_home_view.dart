import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../domain/providers/medicine_provider.dart';
import '../data/models/medicine_model.dart';
import 'widgets/medicine_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../core/widgets/shimmer_loader.dart';

class PharmacyHomeView extends ConsumerWidget {
  const PharmacyHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Search Bar ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.pharmacyPrimary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Iconsax.search_normal,
                      color: AppColors.pharmacyPrimary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => ref
                          .read(medicineSearchQueryProvider.notifier)
                          .state = val,
                      decoration: InputDecoration(
                        hintText: AppStrings.searchMedicineHint,
                        hintStyle: TextStyle(
                            color: context.textMutedColor, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Quick Access Actions ──────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: AppSizes.sm),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Iconsax.message_question,
                    title: AppStrings.askPharmacist,
                    color: AppColors.pharmacyPrimary,
                    onTap: () => context.push('/pharmacy/ask-pharmacist'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Iconsax.clock,
                    title: AppStrings.dosageReminder,
                    color: AppColors.pharmacySecondary,
                    onTap: () => context.push('/pharmacy/dosage-reminders'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Banners ───────────────────────────────────────────
        SliverToBoxAdapter(child: const _PharmacyBannerCarousel()),

        // ── Categories ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
            child: Text(
              AppStrings.categories,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor),
            ),
          ),
        ),
        SliverToBoxAdapter(child: const _MedicineCategoriesRow()),

        // ── Medicines Grid ────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
            child: Text(
              AppStrings.allMedicines,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor),
            ),
          ),
        ),
        const _MedicinesGrid(),

        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }
}

// ── Quick Action Card ─────────────────────────────────────────────────────────
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pharmacy Banner Carousel ──────────────────────────────────────────────────
class _PharmacyBannerCarousel extends StatelessWidget {
  const _PharmacyBannerCarousel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: PageView(
        controller: PageController(viewportFraction: 0.92),
        children: [
          _buildBanner(
            context,
            'Upload Prescription',
            'Get your medicines delivered fast',
            'Upload Now',
            [AppColors.pharmacyGradientStart, AppColors.pharmacyGradientEnd],
            Iconsax.document_upload,
          ),
          _buildBanner(
            context,
            'Free Doctor Consult',
            'Chat with our expert pharmacists',
            'Chat Now',
            [AppColors.pharmacySecondary, AppColors.pharmacyDark],
            Iconsax.messages_2,
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, String title, String sub,
      String btn, List<Color> colors, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    btn,
                    style: TextStyle(
                      color: colors.first,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: Colors.white.withOpacity(0.5), size: 60),
        ],
      ),
    );
  }
}

// ── Categories Row ────────────────────────────────────────────────────────────
class _MedicineCategoriesRow extends ConsumerWidget {
  const _MedicineCategoriesRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(selectedMedicineCategoryProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: MedicineCategory.values.map((cat) {
          final isSelected = selectedCat == cat;
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                ref.read(selectedMedicineCategoryProvider.notifier).state =
                    null;
              } else {
                ref.read(selectedMedicineCategoryProvider.notifier).state =
                    cat;
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.pharmacyPrimary : context.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.pharmacyPrimary
                      : context.borderColor,
                ),
              ),
              child: Row(
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : context.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Medicines Grid ────────────────────────────────────────────────────────────
class _MedicinesGrid extends ConsumerWidget {
  const _MedicinesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(filteredMedicinesProvider);

    return medicinesAsync.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        sliver: SliverGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.70,
          children: List.generate(
            4,
            (index) => const ShimmerLoader(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 16,
            ),
          ),
        ),
      ),
      error: (err, _) => SliverToBoxAdapter(child: Text('Error: $err')),
      data: (medicines) {
        if (medicines.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('No medicines found.',
                    style: TextStyle(color: context.textMutedColor)),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          sliver: SliverGrid.builder(
            itemCount: medicines.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.70,
            ),
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return MedicineCard(
                medicine: medicine,
                onTap: () =>
                    context.push('/pharmacy/medicines/${medicine.id}'),
              );
            },
          ),
        );
      },
    );
  }
}
