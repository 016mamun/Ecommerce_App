import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme_colors.dart';

class PaymentMethodsSheet extends StatefulWidget {
  const PaymentMethodsSheet({super.key});

  @override
  State<PaymentMethodsSheet> createState() => _PaymentMethodsSheetState();
}

class _PaymentMethodsSheetState extends State<PaymentMethodsSheet> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> _methods = [
    {
      'name': 'Visa •••• 4242',
      'sub': 'Expires 08/27',
      'icon': Iconsax.card,
      'color': const Color(0xFF1A1F71),
      'badge': 'VISA',
    },
    {
      'name': 'Mastercard •••• 8765',
      'sub': 'Expires 12/26',
      'icon': Iconsax.card,
      'color': const Color(0xFFEB001B),
      'badge': 'MC',
    },
    {
      'name': 'bKash',
      'sub': '+880 1700-000000',
      'icon': Iconsax.mobile,
      'color': const Color(0xFFE2136E),
      'badge': 'bK',
    },
    {
      'name': 'Nagad',
      'sub': '+880 1700-000000',
      'icon': Iconsax.mobile,
      'color': const Color(0xFFF6821F),
      'badge': 'NG',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Header
          Row(
            children: [
              Text(
                'Payment Methods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddCardDialog(context),
                icon: const Icon(Iconsax.add, size: 16, color: AppColors.primary),
                label: const Text('Add New', style: TextStyle(color: AppColors.primary, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (_, i) {
              final method = _methods[i];
              final isSelected = _selectedMethod == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = i),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : context.borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Badge
                      Container(
                        width: 44,
                        height: 32,
                        decoration: BoxDecoration(
                          color: (method['color'] as Color).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: (method['color'] as Color).withValues(alpha: 0.4)),
                        ),
                        child: Center(
                          child: Text(
                            method['badge'] as String,
                            style: TextStyle(
                              color: method['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'] as String,
                              style: TextStyle(
                                color: context.textPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              method['sub'] as String,
                              style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primary : context.textMutedColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.lg),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Text('Add New Card', style: TextStyle(color: context.textPrimaryColor, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField('Card Number'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildField('MM/YY')),
                const SizedBox(width: 12),
                Expanded(child: _buildField('CVV')),
              ],
            ),
            const SizedBox(height: 12),
            _buildField('Cardholder Name'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: context.textSecondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            child: const Text('Add Card', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint) {
    return TextField(
      style: TextStyle(color: context.textPrimaryColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textMutedColor, fontSize: 13),
        filled: true,
        fillColor: context.bgColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
