import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/meal_model.dart';

class MealLocalDataSource {
  MealLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<void> cacheMeals(List<MealModel> meals) async {
    final encoded = jsonEncode(meals.map((m) => m.toJson()).toList());
    await _prefs.setString(AppConstants.mealsCacheKey, encoded);
  }

  List<MealModel> readCache() {
    final raw = _prefs.getString(AppConstants.mealsCacheKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => MealModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  bool get hasCache => (_prefs.getString(AppConstants.mealsCacheKey) ?? '')
      .isNotEmpty;
}
