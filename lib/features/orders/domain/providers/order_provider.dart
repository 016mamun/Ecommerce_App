import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';

class MockOrderRepository {
  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      OrderModel(
        id: 'ORD-2023-8945',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        totalAmount: 14500,
        itemCount: 3,
        status: OrderStatus.processing,
        deliveryAddress: 'House 12, Road 5, Dhanmondi, Dhaka',
      ),
      OrderModel(
        id: 'ORD-2023-7621',
        date: DateTime.now().subtract(const Duration(days: 2)),
        totalAmount: 3200,
        itemCount: 1,
        status: OrderStatus.shipped,
        deliveryAddress: 'Level 4, Bashundhara City Shopping Mall, Dhaka',
      ),
      OrderModel(
        id: 'ORD-2023-5512',
        date: DateTime.now().subtract(const Duration(days: 15)),
        totalAmount: 124999,
        itemCount: 1,
        status: OrderStatus.delivered,
        deliveryAddress: 'House 12, Road 5, Dhanmondi, Dhaka',
      ),
      OrderModel(
        id: 'ORD-2023-3490',
        date: DateTime.now().subtract(const Duration(days: 45)),
        totalAmount: 1850,
        itemCount: 2,
        status: OrderStatus.cancelled,
        deliveryAddress: 'House 12, Road 5, Dhanmondi, Dhaka',
      ),
    ];
  }
}

final orderRepositoryProvider = Provider<MockOrderRepository>((ref) => MockOrderRepository());

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  return ref.watch(orderRepositoryProvider).getOrders();
});
