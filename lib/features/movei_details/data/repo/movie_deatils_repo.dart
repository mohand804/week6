import 'package:week6/core/networking/api_error_handler.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/core/networking/api_service.dart';
import 'package:week6/features/movei_details/data/cache/movie_deatils_cache_service.dart';
import 'package:week6/features/movei_details/data/model/movie_deatils_model.dart';

class MovieDetailsRepo {
  final ApiService apiService;
  final MovieDetailsCacheService cacheService;

  MovieDetailsRepo({required this.apiService, required this.cacheService});

  Future<ApiResult<MovieDetailsModel>> getMovieDetails(int movieId) async {
    try {
      final cachedDetails = cacheService.getCachedMovieDetails(movieId);
      if (cachedDetails != null) {
        return ApiResult.success(cachedDetails);
      }
      final response = await apiService.movieDetails(movieId);
      await cacheService.cacheMovieDetails(movieId, response);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
