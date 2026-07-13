import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CheckoutStep { address, payment, summary, confirmation }

enum PaymentMethod { creditCard, bkash, nagad, rocket, cod }

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    this.isDefault = false,
  });
}

class CheckoutState {
  final CheckoutStep step;
  final AddressModel? selectedAddress;
  final PaymentMethod? paymentMethod;
  final List<AddressModel> savedAddresses;
  final bool isPlacingOrder;
  final bool orderPlaced;

  const CheckoutState({
    this.step = CheckoutStep.address,
    this.selectedAddress,
    this.paymentMethod,
    this.savedAddresses = const [],
    this.isPlacingOrder = false,
    this.orderPlaced = false,
  });

  CheckoutState copyWith({
    CheckoutStep? step,
    AddressModel? selectedAddress,
    PaymentMethod? paymentMethod,
    List<AddressModel>? savedAddresses,
    bool? isPlacingOrder,
    bool? orderPlaced,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderPlaced: orderPlaced ?? this.orderPlaced,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier()
      : super(CheckoutState(
          savedAddresses: [
            const AddressModel(
              id: 'addr1',
              name: 'Md. Mamun',
              phone: '+880 1712-345678',
              address: 'House 12, Road 5, Dhanmondi',
              city: 'Dhaka',
              isDefault: true,
            ),
            const AddressModel(
              id: 'addr2',
              name: 'Md. Mamun (Office)',
              phone: '+880 1812-345678',
              address: 'Level 4, Bashundhara City Shopping Mall',
              city: 'Dhaka',
            ),
          ],
        )) {
    // Auto-select default address
    state = state.copyWith(
      selectedAddress: state.savedAddresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => state.savedAddresses.first,
      ),
    );
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  void selectPayment(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  void nextStep() {
    switch (state.step) {
      case CheckoutStep.address:
        state = state.copyWith(step: CheckoutStep.payment);
        break;
      case CheckoutStep.payment:
        state = state.copyWith(step: CheckoutStep.summary);
        break;
      case CheckoutStep.summary:
        _placeOrder();
        break;
      default:
        break;
    }
  }

  void prevStep() {
    switch (state.step) {
      case CheckoutStep.payment:
        state = state.copyWith(step: CheckoutStep.address);
        break;
      case CheckoutStep.summary:
        state = state.copyWith(step: CheckoutStep.payment);
        break;
      default:
        break;
    }
  }

  Future<void> _placeOrder() async {
    state = state.copyWith(isPlacingOrder: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isPlacingOrder: false, orderPlaced: true, step: CheckoutStep.confirmation);
  }

  void reset() {
    state = state.copyWith(
      step: CheckoutStep.address,
      orderPlaced: false,
      paymentMethod: null,
    );
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});
