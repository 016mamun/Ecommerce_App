import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../domain/providers/order_provider.dart';
import '../data/models/order_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Track Order', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(child: Text('Failed to load order')),
        data: (orders) {
          final order = orders.firstWhere((o) => o.id == orderId, orElse: () => throw Exception('Order not found'));

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Expected Delivery: Tomorrow by 8:00 PM', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // Tracking Timeline
              const Text('Order Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: AppSizes.md),

              const _TrackingStep(
                title: 'Order Placed',
                subtitle: 'We have received your order',
                isActive: true,
                isCompleted: true,
                icon: Iconsax.document,
              ),
              _TrackingStep(
                title: 'Processing',
                subtitle: 'Your order is being prepared',
                isActive: order.status.index >= OrderStatus.processing.index,
                isCompleted: order.status.index > OrderStatus.processing.index,
                icon: Iconsax.box,
              ),
              _TrackingStep(
                title: 'Shipped',
                subtitle: 'Your order is on the way',
                isActive: order.status.index >= OrderStatus.shipped.index,
                isCompleted: order.status.index > OrderStatus.shipped.index,
                icon: Iconsax.truck_fast,
              ),
              _TrackingStep(
                title: 'Delivered',
                subtitle: 'Your order has been delivered',
                isActive: order.status.index >= OrderStatus.delivered.index,
                isCompleted: order.status.index == OrderStatus.delivered.index,
                isLast: true,
                icon: Iconsax.home,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;
  final IconData icon;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : (isActive ? AppColors.primary.withValues(alpha: 0.2) : AppColors.darkSurface),
                shape: BoxShape.circle,
                border: Border.all(color: isActive || isCompleted ? AppColors.primary : AppColors.darkBorder),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isCompleted ? Colors.white : (isActive ? AppColors.primary : AppColors.textMuted),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.primary : AppColors.darkBorder,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w400, fontSize: 14, color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
