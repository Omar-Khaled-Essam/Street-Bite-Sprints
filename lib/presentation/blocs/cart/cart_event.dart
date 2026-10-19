import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.meal);

  final MealEntity meal;

  @override
  List<Object?> get props => [meal];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.mealId);

  final String mealId;

  @override
  List<Object?> get props => [mealId];
}

class CartQuantityChanged extends CartEvent {
  const CartQuantityChanged(this.mealId, this.quantity);

  final String mealId;
  final int quantity;

  @override
  List<Object?> get props => [mealId, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
