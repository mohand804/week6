import 'package:week6/core/networking/api_error_handler.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/core/networking/api_service.dart';
import 'package:week6/features/home/data/cache/home_cache_service.dart';
import 'package:week6/features/home/data/model/movie_model.dart';

class HomeRepo {
  final ApiService apiService;
  final HomeCacheService homeCacheService;

  HomeRepo({required this.apiService, required this.homeCacheService});

  Future<ApiResult<MovieResponse>> getPopularMovies({int page = 1}) async {
    try {
      final response = await apiService.getPopularMovies(page: page);
      await homeCacheService.cacheMoviesByPage(page, response);
      return ApiResult.success(response);
    } catch (e) {
      final cached = homeCacheService.getCachedMoviesByPage(page);
      if (cached != null) {
        return ApiResult.success(cached);
      }
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
