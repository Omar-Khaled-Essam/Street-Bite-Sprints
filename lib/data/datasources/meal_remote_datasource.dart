import 'package:dio/dio.dart';

import '../../core/error/failures.dart';
import '../../core/network/dio_client.dart';
import '../models/meal_model.dart';

class MealRemoteDataSource {
  MealRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient().dio;

  final Dio _dio;

  Future<List<MealModel>> searchMeals({String query = 'a'}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'search.php',
        queryParameters: {'s': query},
      );
      final meals = response.data?['meals'];
      if (meals is! List) return [];
      return meals
          .map((e) => MealModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException {
      throw const NetworkFailure();
    }
  }

  Future<MealModel> lookupMeal(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'lookup.php',
        queryParameters: {'i': id},
      );
      final meals = response.data?['meals'];
      if (meals is! List || meals.isEmpty) {
        throw const NetworkFailure();
      }
      return MealModel.fromJson(Map<String, dynamic>.from(meals.first as Map));
    } on DioException {
      throw const NetworkFailure();
    }
  }

  Future<List<String>> categories() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('categories.php');
      final list = response.data?['categories'];
      if (list is! List) return [];
      return list
          .map((e) => (e as Map)['strCategory']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } on DioException {
      throw const NetworkFailure();
    }
  }
}
