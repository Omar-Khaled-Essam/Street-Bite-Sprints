import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../data/datasources/meal_local_datasource.dart';
import '../../../domain/usecases/get_meals.dart';
import '../../../domain/repositories/meal_repository.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit({
    required GetMeals getMeals,
    required MealRepository mealRepository,
    required MealLocalDataSource local,
  }) : _getMeals = getMeals,
       _mealRepository = mealRepository,
       _local = local,
       super(const MealsInitial());

  final GetMeals _getMeals;
  final MealRepository _mealRepository;
  final MealLocalDataSource _local;

  Future<void> load({String query = 'a'}) async {
    emit(const MealsLoading());
    try {
      final meals = await _getMeals(query: query);
      final categories = await _mealRepository.getCategories();
      emit(
        MealsLoaded(
          meals: meals,
          categories: categories,
          fromCache: _local.hasCache && meals.isNotEmpty,
          query: query,
        ),
      );
    } on Failure {
      final cached = _local.readCache();
      if (cached.isNotEmpty) {
        emit(
          MealsLoaded(
            meals: cached,
            categories: cached.map((m) => m.category).toSet().toList(),
            fromCache: true,
            query: query,
          ),
        );
      } else {
        emit(const MealsError('networkError'));
      }
    } catch (_) {
      emit(const MealsError('unknownError'));
    }
  }
}
