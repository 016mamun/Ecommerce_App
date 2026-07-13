import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../domain/providers/checkout_provider.dart';
import '../../cart/domain/providers/cart_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);

    if (checkoutState.orderPlaced) {
      return const _OrderSuccessView();
    }

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        leading: GestureDetector(
          onTap: () {
            if (checkoutState.step == CheckoutStep.address) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            } else {
              ref.read(checkoutProvider.notifier).prevStep();
            }
          },
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      body: Column(
        children: [
          _Stepper(currentStep: checkoutState.step),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStepContent(checkoutState.step),
            ),
          ),
          _BottomBar(state: checkoutState),
        ],
      ),
    );
  }

  Widget _buildStepContent(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.address:
        return const _AddressSelectionStep();
      case CheckoutStep.payment:
        return const _PaymentSelectionStep();
      case CheckoutStep.summary:
        return const _OrderSummaryStep();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Stepper ──────────────────────────────────────────────────────────────────
class _Stepper extends StatelessWidget {
  final CheckoutStep currentStep;
  const _Stepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md, horizontal: AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
      ),
      child: Row(
        children: [
          _StepIndicator(
            label: 'Address',
            isActive: currentStep == CheckoutStep.address,
            isCompleted: currentStep.index > CheckoutStep.address.index,
          ),
          _StepDivider(isActive: currentStep.index > CheckoutStep.address.index),
          _StepIndicator(
            label: 'Payment',
            isActive: currentStep == CheckoutStep.payment,
            isCompleted: currentStep.index > CheckoutStep.payment.index,
          ),
          _StepDivider(isActive: currentStep.index > CheckoutStep.payment.index),
          _StepIndicator(
            label: 'Summary',
            isActive: currentStep == CheckoutStep.summary,
            isCompleted: currentStep.index > CheckoutStep.summary.index,
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({required this.label, required this.isActive, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final color = isCompleted || isActive ? AppColors.primary : AppColors.darkBorder;
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primary : (isActive ? Colors.transparent : AppColors.darkSurface),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : (isActive ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w400,
            color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  final bool isActive;
  const _StepDivider({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 16),
        color: isActive ? AppColors.primary : AppColors.darkBorder,
      ),
    );
  }
}

// ── Address Step ─────────────────────────────────────────────────────────────
class _AddressSelectionStep extends ConsumerWidget {
  const _AddressSelectionStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        const Text('Select Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: AppSizes.md),
        ...state.savedAddresses.map((address) {
          final isSelected = state.selectedAddress?.id == address.id;
          return GestureDetector(
            onTap: () => notifier.selectAddress(address),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSizes.sm),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkBorder, width: isSelected ? 2 : 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? AppColors.primary : AppColors.textMuted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(address.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            if (address.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                child: const Text('Default', style: TextStyle(color: AppColors.primary, fontSize: 10)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(address.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${address.address}, ${address.city}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: AppSizes.md),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
      ],
    );
  }
}

// ── Payment Step ─────────────────────────────────────────────────────────────
class _PaymentSelectionStep extends ConsumerWidget {
  const _PaymentSelectionStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        const Text('Select Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: AppSizes.md),
        _PaymentOption(
          title: AppStrings.cashOnDelivery,
          subtitle: 'Pay when you receive',
          icon: Iconsax.money_4,
          isSelected: state.paymentMethod == PaymentMethod.cod,
          onTap: () => notifier.selectPayment(PaymentMethod.cod),
        ),
        _PaymentOption(
          title: AppStrings.creditCard,
          subtitle: 'Visa, Mastercard',
          icon: Iconsax.card,
          isSelected: state.paymentMethod == PaymentMethod.creditCard,
          onTap: () => notifier.selectPayment(PaymentMethod.creditCard),
        ),
        _PaymentOption(
          title: AppStrings.bkash,
          subtitle: 'Pay via bKash',
          icon: Icons.account_balance_wallet,
          iconColor: const Color(0xFFE2136E),
          isSelected: state.paymentMethod == PaymentMethod.bkash,
          onTap: () => notifier.selectPayment(PaymentMethod.bkash),
        ),
        _PaymentOption(
          title: AppStrings.nagad,
          subtitle: 'Pay via Nagad',
          icon: Icons.account_balance_wallet,
          iconColor: const Color(0xFFED1C24),
          isSelected: state.paymentMethod == PaymentMethod.nagad,
          onTap: () => notifier.selectPayment(PaymentMethod.nagad),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkBorder, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor ?? AppColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? AppColors.primary : AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ── Summary Step ─────────────────────────────────────────────────────────────
class _OrderSummaryStep extends ConsumerWidget {
  const _OrderSummaryStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider);
    final cartItems = ref.watch(cartProvider);
    final currency = NumberFormat.currency(locale: 'en_US', symbol: '৳');

    final total = ref.watch(cartTotalProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        const Text('Review Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: AppSizes.md),

        // Delivery Address
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
              const Row(
                children: [
                  Icon(Iconsax.location, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              if (state.selectedAddress != null) ...[
                Text(state.selectedAddress!.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 4),
                Text('${state.selectedAddress!.address}, ${state.selectedAddress!.city}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(state.selectedAddress!.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),

        // Items
        const Text('Items', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...cartItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('${item.quantity}x', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  ),
                  Text(currency.format(item.itemTotal), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
            )),
        const SizedBox(height: AppSizes.lg),
        const Divider(color: AppColors.darkBorder),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total to Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(currency.format(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ],
        ),
      ],
    );
  }
}

// ── Bottom Bar ───────────────────────────────────────────────────────────────
class _BottomBar extends ConsumerWidget {
  final CheckoutState state;
  const _BottomBar({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool canProceed = false;
    String buttonText = 'Continue';

    switch (state.step) {
      case CheckoutStep.address:
        canProceed = state.selectedAddress != null;
        break;
      case CheckoutStep.payment:
        canProceed = state.paymentMethod != null;
        break;
      case CheckoutStep.summary:
        canProceed = true;
        buttonText = 'Place Order';
        break;
      default:
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(top: BorderSide(color: AppColors.darkBorder)),
      ),
      child: SafeArea(
        child: GradientButton(
          label: buttonText,
          isLoading: state.isPlacingOrder,
          onPressed: canProceed ? () => ref.read(checkoutProvider.notifier).nextStep() : null,
        ),
      ),
    );
  }
}

// ── Success Screen ───────────────────────────────────────────────────────────
class _OrderSuccessView extends ConsumerWidget {
  const _OrderSuccessView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
              ),
              const SizedBox(height: AppSizes.lg),
              const Text('Order Placed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text(
                'Your order has been successfully placed. You will receive a confirmation email shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: AppSizes.xxl),
              GradientButton(
                label: 'Track Order',
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  ref.read(checkoutProvider.notifier).reset();
                  context.go(AppRoutes.orderHistory);
                },
              ),
              const SizedBox(height: AppSizes.md),
              OutlinedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  ref.read(checkoutProvider.notifier).reset();
                  context.go(AppRoutes.home);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
