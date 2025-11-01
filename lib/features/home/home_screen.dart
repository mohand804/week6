import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week6/core/helpers/pagination_handler.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
import 'package:week6/features/home/logic/cubit/home_cubit.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart';
import 'package:week6/features/home/widgets/movies_header.dart';
import 'package:week6/features/home/widgets/movies_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with PaginationMixin<HomeScreen> {
  List<Movie> _allMovies = [];
  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPopularMovies(page: 1);
  }

  @override
  bool get canLoadMore => _currentPage < _totalPages;

  @override
  void onLoadMore() {
    context.read<HomeCubit>().getPopularMovies(page: _currentPage + 1);
  }

  void _onSuccess(List<Movie> movies, int page, int total) {
    setState(() {
      if (page == 1) {
        _allMovies = List.from(movies);
      } else {
        _allMovies = [..._allMovies, ...movies];
      }
      _currentPage = page;
      _totalPages = total;
    });
    setLoadingComplete();
  }

  void _onError() {
    setLoadingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MoviesHeader(),
            Expanded(
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) => state.whenOrNull(
                  success: (movies, page, total, _) =>
                      _onSuccess(movies, page, total),
                  error: (_) => _onError(),
                ),
                builder: (context, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (_, __, ___, ____) => MoviesListView(
                    movies: _allMovies,
                    scrollController: scrollController,
                    isLoadingMore: isLoadingMore,
                  ),
                  error: (error) => Center(
                    child: Text(
                      error.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
