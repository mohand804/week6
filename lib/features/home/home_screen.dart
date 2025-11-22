import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week6/features/home/logic/cubit/home_cubit.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart';
import 'package:week6/features/home/widgets/movies_header.dart';
import 'package:week6/features/home/widgets/movies_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadInitialMovies();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<HomeCubit>().loadMoreMovies();
    }
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
                builder: (context, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (movies, isLoadingMore) => MoviesListView(
                    movies: movies,
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
