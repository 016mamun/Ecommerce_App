import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: const Text(AppStrings.notifications, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        leading: GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Text('Today', style: TextStyle(fontWeight: FontWeight.w600, color: context.textSecondaryColor, fontSize: 13)),
          const SizedBox(height: 12),
          _NotificationItem(
            title: 'Order Shipped!',
            message: 'Your order #ORD-2023-7621 has been shipped and is on its way.',
            time: '2h ago',
            icon: Iconsax.truck_fast,
            color: AppColors.primary,
            isUnread: true,
          ),
          _NotificationItem(
            title: 'Flash Sale Alert ⚡',
            message: 'Up to 50% off on premium electronics. Don\'t miss out!',
            time: '5h ago',
            icon: Iconsax.flash,
            color: AppColors.warning,
            isUnread: true,
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Yesterday', style: TextStyle(fontWeight: FontWeight.w600, color: context.textSecondaryColor, fontSize: 13)),
          const SizedBox(height: 12),
          _NotificationItem(
            title: 'Welcome to ShopNest 🎉',
            message: 'Thanks for joining us! Here is a 20% discount code for your first order: WELCOME20',
            time: '1d ago',
            icon: Iconsax.gift,
            color: AppColors.success,
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final bool isUnread;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? context.cardColor : context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? context.borderColor : Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                          color: context.textPrimaryColor,
                        ),
                      ),
                    ),
                    Text(time, style: TextStyle(fontSize: 11, color: context.textMutedColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnread ? context.textSecondaryColor : context.textMutedColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
