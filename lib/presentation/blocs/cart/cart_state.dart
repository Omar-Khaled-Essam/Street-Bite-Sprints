import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  const CartState({
    this.items = const [],
    this.justEmptied = false,
    this.lastAddedName,
  });

  final List<CartItemEntity> items;
  final bool justEmptied;
  final String? lastAddedName;

  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  int quantityFor(String mealId) {
    for (final item in items) {
      if (item.meal.id == mealId) return item.quantity;
    }
    return 0;
  }

  double get mealsTotal =>
      items.fold(0, (sum, item) => sum + item.lineTotal);

  double get deliveryFee => items.isEmpty ? 0 : 3.99;
  double get taxes => mealsTotal * 0.07;
  double get discount => items.isEmpty ? 0 : 4.56;
  double get subtotal =>
      (mealsTotal + deliveryFee + taxes - discount).clamp(0, double.infinity);

  CartState copyWith({
    List<CartItemEntity>? items,
    bool? justEmptied,
    String? lastAddedName,
    bool clearLastAdded = false,
  }) {
    return CartState(
      items: items ?? this.items,
      justEmptied: justEmptied ?? false,
      lastAddedName: clearLastAdded ? null : lastAddedName ?? this.lastAddedName,
    );
  }

  @override
  List<Object?> get props => [items, justEmptied, lastAddedName];
}
