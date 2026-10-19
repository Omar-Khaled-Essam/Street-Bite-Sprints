import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../blocs/orders/orders_cubit.dart';
import '../widgets/network_image_box.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<OrdersCubit, List<OrderEntity>>(
          builder: (context, orders) {
            final active = orders.where((o) => o.status != 'delivered').toList();
            final past = orders.where((o) => o.status == 'delivered').toList();
            return ListView(
              children: [
                Text(
                  l10n.orders,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ...active.map((order) => _tile(context, order, true, l10n)),
                if (orders.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.past,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                ...past.map((order) => _tile(context, order, false, l10n)),
                if (orders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(child: Text(l10n.cartEmpty)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    OrderEntity order,
    bool active,
    AppLocalizations l10n,
  ) {
    final meal = order.items.first.meal;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.tracking, arguments: order),
      leading: NetworkImageBox(
        url: meal.thumbnail,
        width: 64,
        height: 64,
        radius: 16,
      ),
      title: active
          ? Text(
              l10n.arrivesIn('25-30'),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : Text(meal.name),
      subtitle: Text(
        active
            ? meal.name
            : '${l10n.itemsCount(order.items.fold<int>(0, (s, i) => s + i.quantity))} · ${_age(order, l10n)}',
      ),
    );
  }

  String _age(OrderEntity order, AppLocalizations l10n) {
    final days = DateTime.now().difference(order.createdAt).inDays;
    return days == 0 ? l10n.today : l10n.daysAgo(days);
  }
}
