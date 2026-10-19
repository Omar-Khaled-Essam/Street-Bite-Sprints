import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/error/exception_mapper.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/auth_firebase_datasource.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/meal_local_datasource.dart';
import 'data/datasources/meal_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/meal_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/services/firestore_service.dart';
import 'domain/payment/payment_processor.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/meal_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/get_meal_details.dart';
import 'domain/usecases/get_meals.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/place_order.dart';
import 'domain/usecases/register_user.dart';
import 'domain/usecases/toggle_favourite.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favourites/favourites_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/meals/meals_cubit.dart';
import 'presentation/blocs/orders/orders_cubit.dart';
import 'presentation/blocs/profile/profile_cubit.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({required bool firebaseEnabled}) async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<ExceptionMapper>(const ExceptionMapper())
    ..registerSingleton<DioClient>(DioClient())
    ..registerSingleton<FirestoreService>(
      FirestoreService.initialize(
        prefs: prefs,
        firebaseEnabled: firebaseEnabled,
      ),
    )
    ..registerLazySingleton(() => MealRemoteDataSource(dio: sl<DioClient>().dio))
    ..registerLazySingleton(() => MealLocalDataSource(sl()))
    ..registerLazySingleton(
      () => const PaymentProcessor(),
    )
    ..registerLazySingleton(() => AuthLocalDataSource(sl()));

  if (firebaseEnabled) {
    sl.registerLazySingleton(
      () => AuthFirebaseDataSource(FirebaseAuth.instance, sl()),
    );
  }

  sl
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseEnabled: firebaseEnabled,
        firebase: firebaseEnabled ? sl<AuthFirebaseDataSource>() : null,
        local: sl(),
      ),
    )
    ..registerLazySingleton<MealRepository>(
      () => MealRepositoryFactory(sl(), sl()).create(preferCache: false),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => RegisterUser(sl()))
    ..registerLazySingleton(() => GetMeals(sl()))
    ..registerLazySingleton(() => GetMealDetails(sl()))
    ..registerLazySingleton(() => PlaceOrder(sl()))
    ..registerLazySingleton(() => ToggleFavourite(sl()))
    ..registerFactory(
      () => AuthCubit(
        authRepository: sl(),
        loginUser: sl(),
        registerUser: sl(),
      ),
    )
    ..registerFactory(() => ThemeBloc(sl()))
    ..registerFactory(() => LocaleCubit(sl()))
    ..registerFactory(() => CartBloc())
    ..registerFactory(
      () => MealsCubit(getMeals: sl(), mealRepository: sl(), local: sl()),
    )
    ..registerFactory(() => OrdersCubit(sl()))
    ..registerFactory(
      () => FavouritesCubit(repository: sl(), toggleFavourite: sl()),
    )
    ..registerFactory(() => ProfileCubit(sl()));
}
