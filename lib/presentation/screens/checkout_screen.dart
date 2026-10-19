import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/payment/card_payment.dart';
import '../../domain/payment/cash_payment.dart';
import '../../domain/payment/payment_method.dart';
import '../../domain/payment/payment_processor.dart';
import '../../domain/usecases/place_order.dart';
import '../../injection.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../widgets/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool express = false;
  PaymentMethod method = CashPayment();
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cart) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                l10n.checkout,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 140,
                    color: AppColors.mint,
                    child: Center(child: Text(l10n.adjustPin)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.deliveryTime, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _timeCard(
                    title: l10n.express,
                    subtitle: '${l10n.expressEta}\n${l10n.expressFee}',
                    selected: express,
                    onTap: () => setState(() => express = true),
                  ),
                  const SizedBox(width: 12),
                  _timeCard(
                    title: l10n.standard,
                    subtitle: l10n.standardEta,
                    selected: !express,
                    onTap: () => setState(() => express = false),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: AppColors.primary),
                title: Text(l10n.defaultAddressLabel),
                subtitle: Text(l10n.mainEntrance),
                onTap: () => Navigator.pushNamed(context, AppRoutes.address),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(l10n.leaveAtDoor),
                subtitle: Text(l10n.addMoreDetails),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: AppColors.muted),
                title: Text(l10n.defaultPhoneLabel),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.discount_outlined),
                title: Text(l10n.addPromo),
              ),
              RadioGroup<String>(
                groupValue: method.id,
                onChanged: (value) async {
                  if (value == 'cash') {
                    setState(() => method = CashPayment());
                  } else if (value == 'card') {
                    await Navigator.pushNamed(context, AppRoutes.addCard);
                    if (!mounted) return;
                    setState(
                      () => method = CardPayment(cardNumber: '4111111111111111'),
                    );
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'cash',
                      title: Text(l10n.paymentCash),
                    ),
                    RadioListTile<String>(
                      value: 'card',
                      title: Text(l10n.paymentCard),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.placeOrder,
                busy: busy,
                onPressed: cart.items.isEmpty
                    ? null
                    : () async {
                        setState(() => busy = true);
                        final paid = await const PaymentProcessor().process(
                          method,
                          cart.subtotal + (express ? 2.99 : 0),
                        );
                        if (!mounted) return;
                        final auth = context.read<AuthCubit>().state;
                        if (!paid || auth is! AuthAuthenticated) {
                          setState(() => busy = false);
                          return;
                        }
                        final order = OrderEntity(
                          id: const Uuid().v4(),
                          userId: auth.user.id,
                          items: cart.items,
                          total: cart.subtotal + (express ? 2.99 : 0),
                          paymentMethod: method.id,
                          address: AppConstants.defaultAddress,
                          createdAt: DateTime.now(),
                        );
                        await sl<PlaceOrder>()(order);
                        if (!context.mounted) return;
                        context.read<CartBloc>().add(const CartCleared());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.orderPlaced)),
                        );
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.tracking,
                          arguments: order,
                        );
                      },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _timeCard({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.grey.shade300,
              width: 1.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (selected)
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
