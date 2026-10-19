import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal_entity.dart';

abstract class MealsState extends Equatable {
  const MealsState();

  @override
  List<Object?> get props => [];
}

class MealsInitial extends MealsState {
  const MealsInitial();
}

class MealsLoading extends MealsState {
  const MealsLoading();
}

class MealsLoaded extends MealsState {
  const MealsLoaded({
    required this.meals,
    required this.categories,
    this.fromCache = false,
    this.query = '',
  });

  final List<MealEntity> meals;
  final List<String> categories;
  final bool fromCache;
  final String query;

  List<MealEntity> get featured => meals.take(5).toList();
  List<MealEntity> get hotOffers => meals.skip(2).take(5).toList();
  List<MealEntity> get fastest => meals.take(8).toList();

  @override
  List<Object?> get props => [meals, categories, fromCache, query];
}

class MealsError extends MealsState {
  const MealsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
