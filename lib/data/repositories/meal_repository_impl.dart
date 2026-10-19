import '../../core/error/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_datasource.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/meal_model.dart';

/// Factory Pattern: [MealRepositoryFactory] decides whether the repository
/// should read from the remote API or from the SharedPreferences cache.
class MealRepositoryFactory {
  const MealRepositoryFactory(this.remote, this.local);

  final MealRemoteDataSource remote;
  final MealLocalDataSource local;

  MealRepository create({required bool preferCache}) {
    return MealRepositoryImpl._(remote: remote, local: local, preferCache: preferCache);
  }
}

class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl._({
    required MealRemoteDataSource remote,
    required MealLocalDataSource local,
    required bool preferCache,
  }) : _remote = remote,
       _local = local,
       _preferCache = preferCache;

  final MealRemoteDataSource _remote;
  final MealLocalDataSource _local;
  final bool _preferCache;

  @override
  Future<List<MealEntity>> getMeals({String query = 'a'}) async {
    if (_preferCache && _local.hasCache) {
      return _local.readCache();
    }
    try {
      final meals = await _remote.searchMeals(query: query);
      if (meals.isNotEmpty) {
        await _local.cacheMeals(meals);
      }
      return meals;
    } on Failure {
      final cached = _local.readCache();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<MealEntity> getMealById(String id) async {
    try {
      return await _remote.lookupMeal(id);
    } on Failure {
      final cached = _local.readCache().where((m) => m.id == id);
      if (cached.isNotEmpty) return cached.first;
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final remote = await _remote.categories();
      if (remote.isNotEmpty) return remote;
    } on Failure {
      // Fall through to categories derived from cache.
    }
    return _local
        .readCache()
        .map((m) => m.category)
        .toSet()
        .toList();
  }

  List<MealModel> peekCache() => _local.readCache();
}
