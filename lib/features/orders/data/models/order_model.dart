import 'package:equatable/equatable.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel extends Equatable {
  final String id;
  final DateTime date;
  final double totalAmount;
  final int itemCount;
  final OrderStatus status;
  final String deliveryAddress;

  const OrderModel({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.itemCount,
    required this.status,
    required this.deliveryAddress,
  });

  @override
  List<Object?> get props => [id, status];
}
