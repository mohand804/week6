import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week6/core/helpers/pagination_handler.dart';
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
    with PaginationHandler<HomeScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    _homeCubit.getPopularMovies();
  }

  @override
  bool get isLoadingMore => _homeCubit.isLoadingMore;

  @override
  bool get hasReachedMax => !_homeCubit.canLoadMore;

  @override
  void onLoadMore() {
    _homeCubit.loadMoreMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MoviesHeader(),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    success: (movies, currentPage, totalPages, isLoadingMore) {
                      if (movies.isEmpty) {
                        return const Center(child: Text('No movies found'));
                      }
                      return MoviesListView(
                        movies: movies,
                        scrollController: scrollController,
                        isLoadingMore: isLoadingMore,
                      );
                    },
                    error: (error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            error.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeCubit>().getPopularMovies();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
