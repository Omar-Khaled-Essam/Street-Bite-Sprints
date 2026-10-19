import '../entities/meal_entity.dart';

abstract class MealRepository {
  Future<List<MealEntity>> getMeals({String query = 'a'});
  Future<MealEntity> getMealById(String id);
  Future<List<String>> getCategories();
}
