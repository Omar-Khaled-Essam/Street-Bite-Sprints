import 'package:equatable/equatable.dart';

import 'cart_item_entity.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
    this.status = 'preparing',
  });

  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final double total;
  final String paymentMethod;
  final String address;
  final DateTime createdAt;
  final String status;

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    total,
    paymentMethod,
    address,
    createdAt,
    status,
  ];
}
