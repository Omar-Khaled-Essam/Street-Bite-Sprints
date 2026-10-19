import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_helper.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../widgets/network_image_box.dart';
import '../widgets/primary_button.dart';
import '../widgets/quantity_stepper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool delivery = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.mint,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _modeChip(l10n.delivery, delivery, () => setState(() => delivery = true)),
              _modeChip(l10n.pickup, !delivery, () => setState(() => delivery = false)),
            ],
          ),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (prev, next) => next.justEmptied && !prev.justEmptied,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.cartEmpty)));
        },
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(child: Text(l10n.cartEmpty));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                l10n.cart,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...state.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      NetworkImageBox(
                        url: item.meal.thumbnail,
                        width: 64,
                        height: 64,
                        radius: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.meal.name,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(PriceHelper.format(item.meal.price)),
                          ],
                        ),
                      ),
                      QuantityStepper(
                        quantity: item.quantity,
                        onChanged: (q) => context.read<CartBloc>().add(
                          CartQuantityChanged(item.meal.id, q),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.seeMenu,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              const Divider(),
              _row(l10n.cart, PriceHelper.format(state.mealsTotal)),
              _row(l10n.deliveryFee, PriceHelper.format(state.deliveryFee)),
              _row(l10n.feesAndTaxes, PriceHelper.format(state.taxes)),
              _row(
                l10n.discount,
                '-${PriceHelper.format(state.discount)}',
                highlight: true,
              ),
              _row(
                l10n.subtotal,
                PriceHelper.format(state.subtotal),
                bold: true,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l10n.continueLabel,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.checkout),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _modeChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight ? AppColors.primary : null,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppColors.primary : null,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
