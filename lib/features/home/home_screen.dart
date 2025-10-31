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

class _HomeScreenState extends State<HomeScreen> with PaginationHandler {
  List<Movie> allMovies = [];
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPopularMovies(page: 1);
  }

  @override
  bool get hasReachedMax => currentPage >= totalPages;

  @override
  void onLoadMore() {
    context.read<HomeCubit>().getPopularMovies(page: currentPage);
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
                listener: (context, state) {
                  state.maybeWhen(
                    success: (data) {
                      if (currentPage == 1) {
                        allMovies = data.results;
                      } else {
                        allMovies.addAll(data.results);
                      }
                      totalPages = data.totalPages;
                      setState(() {
                        isLoadingMore = false;
                      });
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    loding: () {
                      if (allMovies.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return MoviesListView(
                        movies: allMovies,
                        scrollController: scrollController,
                        isLoadingMore: true,
                      );
                    },
                    success: (data) => MoviesListView(
                      movies: allMovies,
                      scrollController: scrollController,
                      isLoadingMore: isLoadingMore,
                    ),
                    error: (error) => Center(
                      child: Text(
                        error.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
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
