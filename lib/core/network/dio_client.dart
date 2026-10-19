import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Singleton Dio client with logging and basic error conversion.
/// Pattern: Singleton — one HTTP client is shared across the app via GetIt.
class DioClient {
  DioClient._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.mealDbBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  static final DioClient instance = DioClient._internal();

  factory DioClient() => instance;

  final Dio dio;
}
