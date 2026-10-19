import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../../domain/entities/meal_entity.dart';
import 'network_image_box.dart';

class MealGridCard extends StatelessWidget {
  const MealGridCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onAdd,
  });

  final MealEntity meal;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              NetworkImageBox(
                url: meal.thumbnail,
                height: 120,
                width: double.infinity,
                radius: 18,
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: GestureDetector(
                  onTap: onAdd,
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, color: AppColors.primary, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meal.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            '${meal.category} · ${PriceHelper.format(meal.price)}',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
