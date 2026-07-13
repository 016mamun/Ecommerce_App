import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../router/app_router.dart';
import '../theme/app_theme_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/wishlist')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border(top: BorderSide(color: context.borderColor, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: Iconsax.home,
                  activeIcon: Iconsax.home_15,
                  label: AppStrings.home,
                  isActive: currentIndex == 0,
                  onTap: () => context.go(AppRoutes.home),
                ),
                _NavItem(
                  icon: Iconsax.search_normal,
                  activeIcon: Iconsax.search_normal_15,
                  label: AppStrings.explore,
                  isActive: currentIndex == 1,
                  onTap: () => context.go(AppRoutes.explore),
                ),
                _NavItem(
                  icon: Iconsax.shopping_cart,
                  activeIcon: Iconsax.shopping_cart5,
                  label: AppStrings.cart,
                  isActive: currentIndex == 2,
                  onTap: () => context.go(AppRoutes.cart),
                ),
                _NavItem(
                  icon: Iconsax.heart,
                  activeIcon: Iconsax.heart5,
                  label: AppStrings.wishlist,
                  isActive: currentIndex == 3,
                  onTap: () => context.go(AppRoutes.wishlist),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppStrings.profile,
                  isActive: currentIndex == 4,
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  color: isActive ? AppColors.primary : context.textMutedColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primary : context.textMutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
