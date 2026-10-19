import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/meal_entity.dart';
import 'network_image_box.dart';

class FeaturedVendorCard extends StatelessWidget {
  const FeaturedVendorCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  final MealEntity meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rating = (4.3 + (meal.id.hashCode % 7) / 10).toStringAsFixed(1);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageBox(
            url: meal.thumbnail,
            height: 160,
            width: double.infinity,
            radius: 16,
          ),
          const SizedBox(height: 8),
          Text(
            meal.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          Text(
            l10n.ratingDistance(rating, '2.3km', '25 min'),
            style: const TextStyle(color: AppColors.star, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
