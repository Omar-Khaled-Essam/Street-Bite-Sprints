import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/cart_item_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onAdded);
    on<CartItemRemoved>(_onRemoved);
    on<CartQuantityChanged>(_onQuantity);
    on<CartCleared>(_onCleared);
  }

  void _onAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = [...state.items];
    final index = items.indexWhere((e) => e.meal.id == event.meal.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
    } else {
      items.add(CartItemEntity(meal: event.meal, quantity: 1));
    }
    emit(state.copyWith(items: items, lastAddedName: event.meal.name));
  }

  void _onRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final wasNotEmpty = state.items.isNotEmpty;
    final items = state.items.where((e) => e.meal.id != event.mealId).toList();
    emit(
      state.copyWith(
        items: items,
        justEmptied: wasNotEmpty && items.isEmpty,
        clearLastAdded: true,
      ),
    );
  }

  void _onQuantity(CartQuantityChanged event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(CartItemRemoved(event.mealId));
      return;
    }
    final items = state.items
        .map(
          (e) => e.meal.id == event.mealId
              ? e.copyWith(quantity: event.quantity)
              : e,
        )
        .toList();
    emit(state.copyWith(items: items, clearLastAdded: true));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(state.copyWith(items: const [], justEmptied: true, clearLastAdded: true));
  }
}
