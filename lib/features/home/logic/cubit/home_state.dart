import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:week6/core/networking/api_error_model.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.success({
    required List<Movie> movies,
    @Default(false) bool isLoadingMore,
  }) = Success;
  const factory HomeState.error(ApiErrorModel error) = Error;
}
