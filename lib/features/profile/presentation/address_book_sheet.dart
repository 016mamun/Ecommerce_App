import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme_colors.dart';

// Provider for addresses
final addressProvider = StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier();
});

class AddressModel {
  final String id;
  final String label;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? name,
    String? phone,
    String? address,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier()
      : super([
          AddressModel(
            id: '1',
            label: 'Home',
            name: 'Md. Mamun',
            phone: '+880 1700-000000',
            address: 'House 12, Road 5, Dhanmondi, Dhaka-1205',
            isDefault: true,
          ),
          AddressModel(
            id: '2',
            label: 'Office',
            name: 'Md. Mamun',
            phone: '+880 1700-000000',
            address: 'Level 4, Bashundhara City, Panthapath, Dhaka-1215',
          ),
        ]);

  void add(AddressModel address) {
    state = [...state, address];
  }

  void remove(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }
}

class AddressBookSheet extends ConsumerWidget {
  const AddressBookSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

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
                'Address Book',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddAddressDialog(context, ref),
                icon: const Icon(Iconsax.add, size: 16, color: AppColors.primary),
                label: const Text('Add New', style: TextStyle(color: AppColors.primary, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),

          // Address List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (_, i) {
              final addr = addresses[i];
              return _AddressCard(
                address: addr,
                onSetDefault: () => ref.read(addressProvider.notifier).setDefault(addr.id),
                onDelete: () => ref.read(addressProvider.notifier).remove(addr.id),
              );
            },
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final labelCtrl = TextEditingController(text: 'Home');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Text('Add New Address', style: TextStyle(color: context.textPrimaryColor, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(context, 'Label (Home/Office)', labelCtrl),
              const SizedBox(height: 12),
              _buildField(context, 'Full Name', nameCtrl),
              const SizedBox(height: 12),
              _buildField(context, 'Phone', phoneCtrl),
              const SizedBox(height: 12),
              _buildField(context, 'Full Address', addressCtrl, maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.textSecondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && addressCtrl.text.isNotEmpty) {
                ref.read(addressProvider.notifier).add(AddressModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  label: labelCtrl.text.isEmpty ? 'Home' : labelCtrl.text,
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  address: addressCtrl.text,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String hint, TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(color: context.textPrimaryColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textMutedColor, fontSize: 13),
        filled: true,
        fillColor: context.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : context.borderColor,
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: address.isDefault
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  address.label,
                  style: TextStyle(
                    color: address.isDefault ? AppColors.primary : context.textSecondaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (address.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Iconsax.trash, size: 17, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.name,
            style: TextStyle(color: context.textPrimaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            address.phone,
            style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            address.address,
            style: TextStyle(color: context.textSecondaryColor, fontSize: 12),
          ),
          if (!address.isDefault) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onSetDefault,
              child: const Text(
                'Set as Default',
                style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
