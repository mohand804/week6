import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:week6/core/networking/api_error_model.dart';
import 'package:week6/features/movei_details/data/model/movie_deatils_model.dart';

part 'movie_deatils_state.freezed.dart';

@freezed
class MovieDeatilsState with _$MovieDeatilsState {
  const factory MovieDeatilsState.initial() = _Initial;
  const factory MovieDeatilsState.loading() = Loading;
  const factory MovieDeatilsState.success(MovieDetailsModel movieDetails) =
      Success;
  const factory MovieDeatilsState.error(ApiErrorModel error) = Error;
}
