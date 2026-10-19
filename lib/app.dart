import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/restaurant_args.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/meal_entity.dart';
import 'domain/entities/order_entity.dart';
import 'injection.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favourites/favourites_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/meals/meals_cubit.dart';
import 'presentation/blocs/orders/orders_cubit.dart';
import 'presentation/blocs/profile/profile_cubit.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/theme/theme_event.dart';
import 'presentation/blocs/theme/theme_state.dart';
import 'presentation/screens/add_card_screen.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/checkout_screen.dart';
import 'presentation/screens/delivery_address_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/meal_details_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/order_tracking_screen.dart';
import 'presentation/screens/restaurant_screen.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/vendor_map_screen.dart';

class StreetBiteApp extends StatelessWidget {
  const StreetBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeBloc>()..add(const ThemeStarted())),
        BlocProvider(create: (_) => sl<LocaleCubit>()..load()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<CartBloc>()),
        BlocProvider(create: (_) => sl<MealsCubit>()),
        BlocProvider(create: (_) => sl<OrdersCubit>()),
        BlocProvider(create: (_) => sl<FavouritesCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, theme) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'StreetBite',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: theme.mode,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                initialRoute: AppRoutes.splash,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case AppRoutes.splash:
                      return MaterialPageRoute(
                        builder: (_) => const SplashScreen(),
                      );
                    case AppRoutes.onboarding:
                      return MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(),
                      );
                    case AppRoutes.login:
                      return MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      );
                    case AppRoutes.signUp:
                      return MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      );
                    case AppRoutes.shell:
                      return MaterialPageRoute(
                        builder: (_) => const MainShell(),
                      );
                    case AppRoutes.mealDetails:
                      return MaterialPageRoute(
                        builder: (_) => MealDetailsScreen(
                          meal: settings.arguments! as MealEntity,
                        ),
                      );
                    case AppRoutes.cart:
                      return MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      );
                    case AppRoutes.checkout:
                      return MaterialPageRoute(
                        builder: (_) => const CheckoutScreen(),
                      );
                    case AppRoutes.addCard:
                      return MaterialPageRoute(
                        builder: (_) => const AddCardScreen(),
                      );
                    case AppRoutes.address:
                      return MaterialPageRoute(
                        builder: (_) => const DeliveryAddressScreen(),
                      );
                    case AppRoutes.vendors:
                      return MaterialPageRoute(
                        builder: (_) => const VendorMapScreen(),
                      );
                    case AppRoutes.restaurant:
                      return MaterialPageRoute(
                        builder: (_) => RestaurantScreen(
                          args: settings.arguments! as RestaurantArgs,
                        ),
                      );
                    case AppRoutes.tracking:
                      return MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(
                          order: settings.arguments! as OrderEntity,
                        ),
                      );
                    default:
                      return MaterialPageRoute(
                        builder: (_) => const SplashScreen(),
                      );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
