import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/meal_entity.dart';
import 'network_image_box.dart';

class BannerPageView extends StatelessWidget {
  const BannerPageView({super.key, required this.meals, required this.onTap});

  final List<MealEntity> meals;
  final ValueChanged<MealEntity> onTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.18;
    if (meals.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: meals.length,
        controller: PageController(viewportFraction: 0.92),
        itemBuilder: (context, index) {
          final meal = meals[index];
          return GestureDetector(
            onTap: () => onTap(meal),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageBox(url: meal.thumbnail, radius: 18),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 16,
                    top: 16,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.local_offer, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
