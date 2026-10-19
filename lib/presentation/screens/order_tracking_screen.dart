import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../widgets/network_image_box.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.order});

  final OrderEntity order;

  /// The courier is assigned shortly after the kitchen starts cooking.
  bool get _courierAssigned =>
      DateTime.now().difference(order.createdAt) > const Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: AppColors.mint),
                const Center(
                  child: Icon(Icons.map, size: 88, color: AppColors.primary),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(l10n.help),
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                        ),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                children: [
                  Text(
                    l10n.arrivesIn(_courierAssigned ? '10-15' : '25-30'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l10n.preparingOrder,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _step(l10n.orderReceived, true, Icons.check),
                  _step(l10n.cookingOrder, true, Icons.storefront),
                  _step(
                    _courierAssigned ? l10n.courierPicking : l10n.lookingCourier,
                    _courierAssigned,
                    Icons.person_outline,
                  ),
                  _step(l10n.orderDelivered, false, Icons.home_outlined),
                  const Divider(height: 32),
                  if (_courierAssigned) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.mint,
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                      title: const Text(
                        AppConstants.courierName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(l10n.contactCourier),
                      trailing: const Icon(Icons.chat_bubble_outline),
                    ),
                    const Divider(height: 32),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.subtotal,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        PriceHelper.format(order.total),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: NetworkImageBox(
                        url: item.meal.thumbnail,
                        width: 48,
                        height: 48,
                        radius: 12,
                      ),
                      title: Text(item.meal.name),
                      subtitle: Text(PriceHelper.format(item.meal.price)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(String label, bool done, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: done ? AppColors.primary : AppColors.field,
        child: Icon(icon, color: done ? Colors.white : AppColors.muted),
      ),
      title: Text(label),
    );
  }
}
