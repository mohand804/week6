import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week6/core/networking/api_service.dart';
import 'package:week6/core/networking/dio_factory.dart';
import 'package:week6/core/theming/theme_cubit.dart';
import 'package:week6/features/home/data/cache/home_cache_service.dart';
import 'package:week6/features/home/data/repo/home_repo.dart';
import 'package:week6/features/home/logic/cubit/home_cubit.dart';
import 'package:week6/features/movei_details/data/cache/movie_deatils_cache_service.dart';
import 'package:week6/features/movei_details/data/repo/movie_deatils_repo.dart';
import 'package:week6/features/movei_details/logic/cubit/movie_deatils_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  // Register SharedPreferences (needs async initialization)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register ThemeCubit
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<HomeCacheService>(() => HomeCacheService());

  // Register Home Feature
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(
      apiService: getIt<ApiService>(),
      homeCacheService: getIt<HomeCacheService>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));

  // Register Movie Details Feature
  getIt.registerLazySingleton<MovieDetailsCacheService>(
    () => MovieDetailsCacheService(),
  );
  getIt.registerLazySingleton<MovieDetailsRepo>(
    () => MovieDetailsRepo(
      apiService: getIt<ApiService>(),
      cacheService: getIt<MovieDetailsCacheService>(),
    ),
  );
  getIt.registerFactory<MovieDeatilsCubit>(
    () => MovieDeatilsCubit(getIt<MovieDetailsRepo>()),
  );
}
