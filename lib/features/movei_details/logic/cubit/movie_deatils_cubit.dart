import 'package:bloc/bloc.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/features/movei_details/data/repo/movie_deatils_repo.dart';
import 'package:week6/features/movei_details/logic/cubit/movie_deatils_state.dart';

class MovieDeatilsCubit extends Cubit<MovieDeatilsState> {
  final MovieDetailsRepo movieDetailsRepo;
  MovieDeatilsCubit(this.movieDetailsRepo) : super(MovieDeatilsState.initial());

  Future<void> getMovieDetails(int movieId) async {
    emit(MovieDeatilsState.loading());
    final result = await movieDetailsRepo.getMovieDetails(movieId);
    result.when(
      success: (data) => emit(MovieDeatilsState.success(data)),
      failure: (error) => emit(MovieDeatilsState.error(error)),
    );
  }
}
