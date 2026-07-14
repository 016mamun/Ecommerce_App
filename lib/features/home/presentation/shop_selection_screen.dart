import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../core/providers/app_mode_provider.dart';

class ShopSelectionScreen extends ConsumerWidget {
  const ShopSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to ShopNest',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your shopping experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 40),
              _SelectionCard(
                title: AppStrings.lifestyleMode,
                imagePath: 'assets/icons/ecompounding Chemist.png',
                gradient: const [AppColors.gradientStart, AppColors.gradientBlue],
                onTap: () {
                  ref.read(appModeProvider.notifier).switchTo(AppMode.lifestyle);
                  context.go(AppRoutes.home);
                },
              ),
              const SizedBox(height: 16),
              _SelectionCard(
                title: AppStrings.pharmacyMode,
                imagePath: 'assets/icons/Kersbrook pharmacy.png',
                gradient: const [AppColors.pharmacyGradientStart, AppColors.pharmacyGradientEnd],
                onTap: () {
                  ref.read(appModeProvider.notifier).switchTo(AppMode.pharmacy);
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.imagePath,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
