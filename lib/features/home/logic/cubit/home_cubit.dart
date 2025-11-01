import 'package:bloc/bloc.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
import 'package:week6/features/home/data/repo/home_repo.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  List<Movie> _allMovies = [];
  int _currentPage = 0;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  HomeCubit(this.homeRepo) : super(const HomeState.initial());

  Future<void> getPopularMovies() async {
    emit(const HomeState.loading());
    _currentPage = 1;
    _allMovies = [];

    final result = await homeRepo.getPopularMovies(page: 1);
    result.when(
      success: (data) {
        _allMovies = data.results;
        _currentPage = data.page;
        _totalPages = data.totalPages;
        _isLoadingMore = false;

        emit(
          HomeState.success(
            movies: _allMovies,
            currentPage: _currentPage,
            totalPages: _totalPages,
            isLoadingMore: false,
          ),
        );
      },
      failure: (error) {
        emit(HomeState.error(error));
      },
    );
  }

  /// Load more movies (pagination)
  Future<void> loadMoreMovies() async {
    // Guard: prevent multiple simultaneous requests
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    _isLoadingMore = true;

    // Emit current state with loading indicator
    emit(
      HomeState.success(
        movies: _allMovies,
        currentPage: _currentPage,
        totalPages: _totalPages,
        isLoadingMore: true,
      ),
    );

    final result = await homeRepo.getPopularMovies(page: _currentPage + 1);

    result.when(
      success: (data) {
        _currentPage = data.page;
        _totalPages = data.totalPages;
        _allMovies.addAll(data.results);
        _isLoadingMore = false;

        emit(
          HomeState.success(
            movies: List.from(_allMovies), // Create new list to trigger rebuild
            currentPage: _currentPage,
            totalPages: _totalPages,
            isLoadingMore: false,
          ),
        );
      },
      failure: (error) {
        _isLoadingMore = false;

        // Keep current movies but show error somehow
        // You might want to add an error state that preserves the movies
        emit(
          HomeState.success(
            movies: _allMovies,
            currentPage: _currentPage,
            totalPages: _totalPages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Check if more movies can be loaded
  bool get canLoadMore => _currentPage < _totalPages && !_isLoadingMore;

  /// Get current page number
  int get currentPage => _currentPage;

  /// Get total pages
  int get totalPages => _totalPages;

  /// Whether a pagination request is currently in-flight.
  bool get isLoadingMore => _isLoadingMore;
}
