import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/routes/restaurant_args.dart';
import '../../core/theme/app_colors.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/meals/meals_state.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _controller = TextEditingController();

  final _icons = const [
    Icons.ramen_dining,
    Icons.local_pizza,
    Icons.fastfood,
    Icons.eco,
    Icons.energy_savings_leaf,
    Icons.icecream,
    Icons.set_meal,
    Icons.soup_kitchen,
  ];

  static const _fallback = [
    'Ramen',
    'Pizza',
    'Fast Food',
    'Healthy',
    'Salads',
    'Desserts',
    'Meat',
    'Asian',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.search,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              onSubmitted: (value) =>
                  context.read<MealsCubit>().load(query: value),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.categories,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<MealsCubit, MealsState>(
                builder: (context, state) {
                  final cats = state is MealsLoaded && state.categories.isNotEmpty
                      ? state.categories.take(8).toList()
                      : _fallback;
                  return GridView.builder(
                    itemCount: cats.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.7,
                        ),
                    itemBuilder: (context, index) {
                      final label = cats[index];
                      return InkWell(
                        onTap: () {
                          final image = state is MealsLoaded &&
                                  state.meals.isNotEmpty
                              ? state.meals[index % state.meals.length].thumbnail
                              : '';
                          Navigator.pushNamed(
                            context,
                            AppRoutes.restaurant,
                            arguments: RestaurantArgs(
                              title: label,
                              imageUrl: image,
                              category: label,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.mint,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _icons[index % _icons.length],
                                color: AppColors.primaryDark,
                              ),
                              const Spacer(),
                              Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
