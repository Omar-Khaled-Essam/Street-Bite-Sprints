import '../entities/meal_entity.dart';
import '../repositories/meal_repository.dart';

class GetMealDetails {
  GetMealDetails(this._repository);

  final MealRepository _repository;

  Future<MealEntity> call(String id) => _repository.getMealById(id);
}
