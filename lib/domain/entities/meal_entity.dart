import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  const MealEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnail,
    required this.instructions,
    required this.price,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnail;
  final String instructions;
  final double price;
  final List<String> tags;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    thumbnail,
    instructions,
    price,
  ];
}
