import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

// Settings state
final _notifOrderProvider = StateProvider<bool>((ref) => true);
final _notifPromoProvider = StateProvider<bool>((ref) => true);
final _notifNewsProvider = StateProvider<bool>((ref) => false);
final _darkModeProvider = StateProvider<bool>((ref) => true);
final _biometricProvider = StateProvider<bool>((ref) => false);

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifOrder = ref.watch(_notifOrderProvider);
    final notifPromo = ref.watch(_notifPromoProvider);
    final notifNews = ref.watch(_notifNewsProvider);
    final darkMode = ref.watch(_darkModeProvider);
    final biometric = ref.watch(_biometricProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.darkBorder, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: AppSizes.md),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: AppSizes.md),

          // Appearance
          _SectionTitle('Appearance'),
          _SettingsToggle(
            icon: Iconsax.moon,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: darkMode,
            onChanged: (v) => ref.read(_darkModeProvider.notifier).state = v,
          ),

          const SizedBox(height: AppSizes.sm),
          _SectionTitle('Notifications'),
          _SettingsToggle(
            icon: Iconsax.bag_2,
            title: 'Order Updates',
            subtitle: 'Get notified on order status changes',
            value: notifOrder,
            onChanged: (v) => ref.read(_notifOrderProvider.notifier).state = v,
          ),
          _SettingsToggle(
            icon: Iconsax.discount_shape,
            title: 'Promotions & Offers',
            subtitle: 'Deals, discounts and promo codes',
            value: notifPromo,
            onChanged: (v) => ref.read(_notifPromoProvider.notifier).state = v,
          ),
          _SettingsToggle(
            icon: Iconsax.notification,
            title: 'News & Updates',
            subtitle: 'Latest news and app updates',
            value: notifNews,
            onChanged: (v) => ref.read(_notifNewsProvider.notifier).state = v,
          ),

          const SizedBox(height: AppSizes.sm),
          _SectionTitle('Security'),
          _SettingsToggle(
            icon: Iconsax.finger_scan,
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            value: biometric,
            onChanged: (v) => ref.read(_biometricProvider.notifier).state = v,
          ),

          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
