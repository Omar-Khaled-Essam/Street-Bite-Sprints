import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../../domain/entities/meal_entity.dart';
import 'network_image_box.dart';

class HotOfferCard extends StatelessWidget {
  const HotOfferCard({super.key, required this.meal, required this.onTap});

  final MealEntity meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.mint,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            NetworkImageBox(url: meal.thumbnail, height: 88, width: 88, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      PriceHelper.format(meal.price * 0.8),
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
