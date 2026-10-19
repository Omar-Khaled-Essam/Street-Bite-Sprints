import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/routes/restaurant_args.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../../domain/entities/meal_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/meals/meals_state.dart';
import '../widgets/network_image_box.dart';
import '../widgets/primary_button.dart';
import '../widgets/quantity_stepper.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key, required this.args});

  final RestaurantArgs args;

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
          return BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              final all = state is MealsLoaded ? state.meals : <MealEntity>[];
              final meals = all
                  .where(
                    (m) =>
                        m.category.toLowerCase() ==
                            args.category.toLowerCase() ||
                        m.area.toLowerCase() == args.category.toLowerCase(),
                  )
                  .toList();
              final menu = meals.isEmpty ? all : meals;
              final tabs = <String>{
                l10n.popular,
                l10n.newLabel,
                ...menu.map((m) => m.category),
              }.take(6).toList();

              return DefaultTabController(
                length: tabs.length,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: NetworkImageBox(
                          url: args.imageUrl,
                          radius: 0,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              args.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.ratingDistance('4.8', '2.3km', '25 min')}  ${l10n.reviewsCount(103)}',
                              style: const TextStyle(color: AppColors.muted),
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
                            const SizedBox(height: 8),
                            TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.muted,
                              indicatorColor: AppColors.primary,
                              tabs: tabs.map((t) => Tab(text: t)).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        final meal = menu[index];
                        final qty = cart.quantityFor(meal.id);
                        return ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.mealDetails,
                            arguments: meal,
                          ),
                          leading: NetworkImageBox(
                            url: meal.thumbnail,
                            width: 56,
                            height: 56,
                            radius: 12,
                          ),
                          title: Text(meal.name),
                          subtitle: Text(PriceHelper.format(meal.price)),
                          trailing: qty == 0
                              ? IconButton(
                                  onPressed: () => context.read<CartBloc>().add(
                                        CartItemAdded(meal),
                                      ),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.primary,
                                  ),
                                )
                              : QuantityStepper(
                                  quantity: qty,
                                  onChanged: (value) => context
                                      .read<CartBloc>()
                                      .add(CartQuantityChanged(meal.id, value)),
                                ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 88)),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cart) {
          if (cart.totalCount == 0) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                label: l10n.continueLabel,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
            ),
          );
        },
      ),
    );
  }
}
