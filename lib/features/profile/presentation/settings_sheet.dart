import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/theme_provider.dart';

// Notification settings state
final _notifOrderProvider = StateProvider<bool>((ref) => true);
final _notifPromoProvider = StateProvider<bool>((ref) => true);
final _notifNewsProvider = StateProvider<bool>((ref) => false);
final _biometricProvider = StateProvider<bool>((ref) => false);

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifOrder = ref.watch(_notifOrderProvider);
    final notifPromo = ref.watch(_notifPromoProvider);
    final notifNews = ref.watch(_notifNewsProvider);
    final biometric = ref.watch(_biometricProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: context.borderColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: AppSizes.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Appearance
          _SectionTitle('Appearance'),
          _SettingsToggle(
            icon: isDark ? Iconsax.moon : Iconsax.sun_1,
            title: 'Dark Mode',
            subtitle: isDark ? 'Switch to light theme' : 'Switch to dark theme',
            value: isDark,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(
              v ? ThemeMode.dark : ThemeMode.light,
            ),
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
          style: TextStyle(
            color: context.textMutedColor,
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
        color: context.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: context.textPrimaryColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: context.textPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: context.textSecondaryColor, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
