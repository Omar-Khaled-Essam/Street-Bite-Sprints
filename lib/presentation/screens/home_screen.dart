import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/routes/restaurant_args.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/meal_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/locale/locale_cubit.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/meals/meals_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../widgets/banner_page_view.dart';
import '../widgets/category_circle.dart';
import '../widgets/featured_vendor_card.dart';
import '../widgets/hot_offer_card.dart';
import '../widgets/meal_grid_card.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onOpenBrowse});

  final VoidCallback? onOpenBrowse;

  void _openMeal(BuildContext context, MealEntity meal) {
    Navigator.pushNamed(context, AppRoutes.mealDetails, arguments: meal);
  }

  void _openRestaurant(BuildContext context, MealEntity meal) {
    Navigator.pushNamed(
      context,
      AppRoutes.restaurant,
      arguments: RestaurantArgs(
        title: meal.name,
        imageUrl: meal.thumbnail,
        category: meal.category,
      ),
    );
  }

  void _addToCart(BuildContext context, MealEntity meal) {
    context.read<CartBloc>().add(CartItemAdded(meal));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final icons = <IconData>[
      Icons.ramen_dining,
      Icons.eco,
      Icons.local_pizza,
      Icons.set_meal,
      Icons.lunch_dining,
      Icons.icecream,
    ];

    return SafeArea(
      child: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            current.lastAddedName != null && current.items != previous.items,
        listener: (context, cart) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          final messenger = ScaffoldMessenger.of(context);
          messenger.removeCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              key: const ValueKey('added_to_cart_snackbar'),
              content: Text(l10n.addedToCart),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: l10n.viewCart,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
            ),
          );
        },
        builder: (context, cart) {
          return BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              if (state is MealsLoading || state is MealsInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MealsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.networkError),
                      TextButton(
                        onPressed: () => context.read<MealsCubit>().load(),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }
              final loaded = state as MealsLoaded;
              final width = MediaQuery.sizeOf(context).width;
              final crossAxis = width > 500 ? 3 : 2;
              return RefreshIndicator(
                onRefresh: () => context.read<MealsCubit>().load(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.address,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.defaultAddressLabel,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: l10n.themeToggle,
                                  onPressed: () => context
                                      .read<ThemeBloc>()
                                      .add(const ThemeToggled()),
                                  icon: const Icon(Icons.brightness_6_outlined),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      context.read<LocaleCubit>().toggle(),
                                  icon: const Icon(Icons.language),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.vendors,
                                  ),
                                  icon: const Icon(Icons.map_outlined),
                                ),
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.cart,
                                      ),
                                      icon: const Icon(
                                        Icons.shopping_bag_outlined,
                                      ),
                                    ),
                                    if (cart.totalCount > 0)
                                      Positioned(
                                        right: 6,
                                        top: 6,
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: AppColors.primary,
                                          child: Text(
                                            '${cart.totalCount}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: onOpenBrowse,
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: l10n.searchHint,
                                    prefixIcon: const Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 86,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: loaded.categories.take(8).length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final label = loaded.categories[index];
                                  return CategoryCircle(
                                    label: label,
                                    icon: icons[index % icons.length],
                                    onTap: () => context
                                        .read<MealsCubit>()
                                        .load(query: label),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            BannerPageView(
                              meals: loaded.featured,
                              onTap: (m) => _openMeal(context, m),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.hotOffers,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 96,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: loaded.hotOffers
                                    .map(
                                      (meal) => HotOfferCard(
                                        meal: meal,
                                        onTap: () => _openMeal(context, meal),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.fastest,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 170,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: loaded.fastest.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final meal = loaded.fastest[index];
                                  return RestaurantCard(
                                    meal: meal,
                                    onTap: () => _openRestaurant(context, meal),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.recommended,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...loaded.meals.take(3).map(
                                  (meal) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: FeaturedVendorCard(
                                      meal: meal,
                                      onTap: () =>
                                          _openRestaurant(context, meal),
                                    ),
                                  ),
                                ),
                            Text(
                              l10n.meals,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        key: const ValueKey('meals_grid'),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final meal = loaded.meals[index];
                          return MealGridCard(
                            meal: meal,
                            onTap: () => _openMeal(context, meal),
                            onAdd: () => _addToCart(context, meal),
                          );
                        }, childCount: loaded.meals.length),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
