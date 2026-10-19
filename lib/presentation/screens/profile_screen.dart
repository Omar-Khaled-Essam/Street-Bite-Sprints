import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../domain/entities/meal_entity.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/favourites/favourites_cubit.dart';
import '../blocs/locale/locale_cubit.dart';
import '../blocs/meals/meals_cubit.dart';
import '../blocs/meals/meals_state.dart';
import '../blocs/orders/orders_cubit.dart';
import '../blocs/profile/profile_cubit.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../widgets/network_image_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthCubit>().state;
    if (auth is AuthAuthenticated) {
      context.read<ProfileCubit>().load(auth.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: BlocBuilder<ProfileCubit, ProfileViewState>(
        builder: (context, profile) {
          final user = profile.user;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.read<ProfileCubit>().pickPhoto(),
                    child: _avatar(user),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(user?.email ?? ''),
                        if (profile.deviceLabel.isNotEmpty)
                          Text(
                            '${l10n.deviceDetails}: ${profile.deviceLabel}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.tune),
                title: Text(l10n.settings),
              ),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, theme) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.darkMode),
                    value: theme.isDark,
                    onChanged: (_) =>
                        context.read<ThemeBloc>().add(const ThemeToggled()),
                  );
                },
              ),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      locale.languageCode == 'ar' ? l10n.arabic : l10n.english,
                    ),
                    subtitle: Text(l10n.language),
                    value: locale.languageCode == 'ar',
                    onChanged: (_) => context.read<LocaleCubit>().toggle(),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(l10n.contactUs),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.help_outline),
                title: Text(l10n.helpCenter),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.map_outlined),
                title: Text(l10n.nearbyVendors),
                onTap: () => Navigator.pushNamed(context, AppRoutes.vendors),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.favourites,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              BlocBuilder<FavouritesCubit, List<String>>(
                builder: (context, ids) {
                  final mealsState = context.watch<MealsCubit>().state;
                  final meals = mealsState is MealsLoaded
                      ? mealsState.meals.where((m) => ids.contains(m.id))
                      : const <MealEntity>[];
                  if (ids.isEmpty) {
                    return const SizedBox(height: 8);
                  }
                  return Column(
                    children: meals
                        .map(
                          (m) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: NetworkImageBox(
                              url: m.thumbnail,
                              width: 48,
                              height: 48,
                              radius: 12,
                            ),
                            title: Text(m.name),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                l10n.orderHistory,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              BlocBuilder<OrdersCubit, List<dynamic>>(
                builder: (context, orders) {
                  return Text(l10n.itemsCount(orders.length));
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  await context.read<AuthCubit>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.onboarding,
                      (_) => false,
                    );
                  }
                },
                child: Text(l10n.logout),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _avatar(UserEntity? user) {
    final photo = user?.photoUrl;
    if (photo != null && photo.startsWith('data:')) {
      final b64 = photo.split(',').last;
      return CircleAvatar(
        radius: 36,
        backgroundImage: MemoryImage(base64Decode(b64)),
      );
    }
    if (photo != null && photo.startsWith('http')) {
      return CircleAvatar(radius: 36, backgroundImage: NetworkImage(photo));
    }
    return const CircleAvatar(
      radius: 36,
      backgroundColor: AppColors.mint,
      child: Icon(Icons.person, color: AppColors.primary, size: 36),
    );
  }
}
