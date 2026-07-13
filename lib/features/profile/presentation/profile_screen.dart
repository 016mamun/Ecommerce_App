import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../auth/domain/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/shimmer_loader.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text(AppStrings.myProfile, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Iconsax.notification),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            // User Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: user?['avatar'] != null
                        ? CachedNetworkImage(
                            imageUrl: user!['avatar'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const ShimmerLoader(width: 60, height: 60, borderRadius: 30),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.white24,
                            child: const Icon(Iconsax.user, color: Colors.white, size: 28),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?['name'] ?? 'Guest User',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?['email'] ?? 'Login to view profile',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (user?['isGuest'] != true)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Iconsax.edit, color: Colors.white, size: 18),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Options
            _ProfileMenu(
              title: AppStrings.myOrders,
              icon: Iconsax.bag_2,
              onTap: () => context.push(AppRoutes.orderHistory),
            ),
            _ProfileMenu(
              title: AppStrings.addressBook,
              icon: Iconsax.location,
              onTap: () {}, // Add Address UI
            ),
            _ProfileMenu(
              title: 'Payment Methods',
              icon: Iconsax.card,
              onTap: () {},
            ),
            const SizedBox(height: AppSizes.lg),
            const Divider(color: AppColors.darkBorder),
            const SizedBox(height: AppSizes.lg),

            _ProfileMenu(
              title: AppStrings.settings,
              icon: Iconsax.setting_2,
              onTap: () {},
            ),
            _ProfileMenu(
              title: AppStrings.helpSupport,
              icon: Iconsax.message_question,
              onTap: () {},
            ),
            _ProfileMenu(
              title: AppStrings.privacyPolicy,
              icon: Iconsax.shield_tick,
              onTap: () {},
            ),
            const SizedBox(height: AppSizes.xl),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go(AppRoutes.login);
              },
              icon: const Icon(Iconsax.logout, color: AppColors.error),
              label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileMenu({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
    );
  }
}
