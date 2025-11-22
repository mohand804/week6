import 'package:bloc/bloc.dart';
import 'package:week6/core/helpers/pagination_handler.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
import 'package:week6/features/home/data/repo/home_repo.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  final PaginationHandler<Movie> _paginationHandler =
      PaginationHandler<Movie>();

  HomeCubit(this.homeRepo) : super(const HomeState.initial());

  PaginationHandler<Movie> get paginationHandler => _paginationHandler;

  Future<void> loadInitialMovies() async {
    emit(const HomeState.loading());
    await _loadMovies();
  }

  Future<void> loadMoreMovies() async {
    if (!_paginationHandler.canLoadMore) return;

    _paginationHandler.startLoading();
    emit(
      HomeState.success(movies: _paginationHandler.items, isLoadingMore: true),
    );
    await _loadMovies();
  }

  Future<void> _loadMovies() async {
    final result = await homeRepo.getPopularMovies(
      page: _paginationHandler.nextPage,
    );

    result.when(
      success: (data) {
        _paginationHandler.addPage(data.results, data.page, data.totalPages);
        emit(
          HomeState.success(
            movies: _paginationHandler.items,
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
