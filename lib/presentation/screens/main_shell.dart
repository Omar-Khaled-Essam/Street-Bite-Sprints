import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/favourites/favourites_cubit.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/orders/orders_cubit.dart';
import '../widgets/streetbite_nav_bar.dart';
import 'browse_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  bool _profileUnlocked = false;

  @override
  void initState() {
    super.initState();
    context.read<MealsCubit>().load();
    final auth = context.read<AuthCubit>().state;
    if (auth is AuthAuthenticated) {
      context.read<FavouritesCubit>().watch(auth.user.id);
      context.read<OrdersCubit>().watch(auth.user.id);
    }
  }

  Future<void> _onNav(int value) async {
    if (value == 3 && !_profileUnlocked) {
      final l10n = AppLocalizations.of(context);
      final auth = LocalAuthentication();
      var ok = false;
      try {
        final supported = await auth.isDeviceSupported();
        if (supported) {
          ok = await auth.authenticate(
            localizedReason: l10n.biometricPrompt,
            options: const AuthenticationOptions(biometricOnly: true),
          );
        } else {
          ok = true;
        }
      } catch (_) {
        ok = true;
      }
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.biometricFailed)));
        }
        return;
      }
      _profileUnlocked = true;
    }
    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenBrowse: () => _onNav(1)),
      const BrowseScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: StreetBiteNavBar(index: _index, onChanged: _onNav),
    );
  }
}
