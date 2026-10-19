import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import 'meal_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.total,
    required super.paymentMethod,
    required super.address,
    required super.createdAt,
    super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return OrderModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      items: rawItems
          .map(
            (item) => CartItemEntity(
              meal: MealModel.fromJson(
                Map<String, dynamic>.from(item['meal'] as Map),
              ),
              quantity: (item['quantity'] as num?)?.toInt() ?? 1,
            ),
          )
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      paymentMethod: (json['paymentMethod'] ?? 'cash').toString(),
      address: (json['address'] ?? '').toString(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: (json['status'] ?? 'preparing').toString(),
    );
  }

  factory OrderModel.fromEntity(OrderEntity order) {
    return OrderModel(
      id: order.id,
      userId: order.userId,
      items: order.items,
      total: order.total,
      paymentMethod: order.paymentMethod,
      address: order.address,
      createdAt: order.createdAt,
      status: order.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items
        .map(
          (item) => {
            'quantity': item.quantity,
            'meal': MealModel(
              id: item.meal.id,
              name: item.meal.name,
              category: item.meal.category,
              area: item.meal.area,
              thumbnail: item.meal.thumbnail,
              instructions: item.meal.instructions,
              price: item.meal.price,
              tags: item.meal.tags,
            ).toJson(),
          },
        )
        .toList(),
    'total': total,
    'paymentMethod': paymentMethod,
    'address': address,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };
}
