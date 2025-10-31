import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:week6/core/networking/api_constants.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
import 'package:week6/features/movei_details/data/model/movie_deatils_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.getPopularMovies)
  Future<MovieResponse> getPopularMovies({@Query('page') int? page});
  @GET(ApiConstants.apiMovieDetails)
  Future<MovieDetailsModel> movieDetails(@Path('movie_id') int id);
}
