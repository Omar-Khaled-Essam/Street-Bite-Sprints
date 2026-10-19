import '../entities/meal_entity.dart';
import '../repositories/meal_repository.dart';

class GetMeals {
  GetMeals(this._repository);

  final MealRepository _repository;

  Future<List<MealEntity>> call({String query = 'a'}) {
    return _repository.getMeals(query: query);
  }
}
