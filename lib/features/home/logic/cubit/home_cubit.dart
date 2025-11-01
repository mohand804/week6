import 'package:bloc/bloc.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/features/home/data/repo/home_repo.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(const HomeState.initial());

  Future<void> getPopularMovies({int page = 1}) async {
    if (page == 1) {
      emit(const HomeState.loading());
    }

    final result = await homeRepo.getPopularMovies(page: page);
    result.when(
      success: (data) {
        emit(
          HomeState.success(
            movies: data.results,
            currentPage: data.page,
            totalPages: data.totalPages,
            isLoadingMore: false,
          ),
        );
      },
      failure: (error) {
        emit(HomeState.error(error));
      },
    );
  }
}
