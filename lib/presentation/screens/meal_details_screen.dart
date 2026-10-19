import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../../domain/entities/meal_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/favourites/favourites_cubit.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/meals/meals_state.dart';
import '../widgets/network_image_box.dart';
import '../widgets/primary_button.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final MealEntity meal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            current.lastAddedName != null && current.items != previous.items,
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          final messenger = ScaffoldMessenger.of(context);
          messenger.removeCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              key: const ValueKey('added_to_cart_snackbar'),
              content: Text(l10n.addedToCart),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        builder: (context, cart) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                actions: [
                  BlocBuilder<FavouritesCubit, List<String>>(
                    builder: (context, favs) {
                      final saved = favs.contains(meal.id);
                      return IconButton(
                        onPressed: () {
                          context.read<FavouritesCubit>().toggle(meal.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                saved
                                    ? l10n.favouriteRemoved
                                    : l10n.favouriteSaved,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          saved ? Icons.bookmark : Icons.bookmark_border,
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: NetworkImageBox(url: meal.thumbnail, radius: 0),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.ratingDistance('4.8', '2.3km', '25 min'),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.promoBannerTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.promoBannerBody,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${l10n.category}: ${meal.category}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('${l10n.origin}: ${meal.area}'),
                      Text(PriceHelper.format(meal.price)),
                      const SizedBox(height: 16),
                      Text(
                        l10n.instructions,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(meal.instructions),
                      const SizedBox(height: 20),
                      Text(
                        l10n.popular,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<MealsCubit, MealsState>(
                        builder: (context, state) {
                          final related = state is MealsLoaded
                              ? state.meals
                                  .where((m) => m.category == meal.category)
                                  .take(6)
                                  .toList()
                              : <MealEntity>[];
                          return Column(
                            children: related
                                .map(
                                  (item) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: NetworkImageBox(
                                      url: item.thumbnail,
                                      width: 54,
                                      height: 54,
                                      radius: 12,
                                    ),
                                    title: Text(item.name),
                                    subtitle: Text(
                                      PriceHelper.format(item.price),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () => context
                                          .read<CartBloc>()
                                          .add(CartItemAdded(item)),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: '${l10n.addToCart} · ${PriceHelper.format(meal.price)}',
            onPressed: () => context.read<CartBloc>().add(CartItemAdded(meal)),
          ),
        ),
      ),
    );
  }
}
