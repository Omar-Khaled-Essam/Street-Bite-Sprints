import '../../core/utils/price_helper.dart';
import '../../domain/entities/meal_entity.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.category,
    required super.area,
    required super.thumbnail,
    required super.instructions,
    required super.price,
    super.tags,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final id = (json['idMeal'] ?? json['id'] ?? '').toString();
    return MealModel(
      id: id,
      name: (json['strMeal'] ?? json['name'] ?? '').toString(),
      category: (json['strCategory'] ?? json['category'] ?? 'Meal').toString(),
      area: (json['strArea'] ?? json['area'] ?? '').toString(),
      thumbnail: (json['strMealThumb'] ?? json['thumbnail'] ?? '').toString(),
      instructions: (json['strInstructions'] ?? json['instructions'] ?? '')
          .toString(),
      price: (json['price'] as num?)?.toDouble() ?? PriceHelper.fromId(id),
      tags: (json['strTags'] as String?)
              ?.split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strCategory': category,
    'strArea': area,
    'strMealThumb': thumbnail,
    'strInstructions': instructions,
    'price': price,
    'strTags': tags.join(','),
  };

  MealEntity toEntity() => this;
}
