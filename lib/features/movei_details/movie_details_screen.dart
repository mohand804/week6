import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week6/core/helpers/spacing.dart';
import 'package:week6/features/movei_details/logic/cubit/movie_deatils_cubit.dart';
import 'package:week6/features/movei_details/logic/cubit/movie_deatils_state.dart';
import 'package:week6/features/movei_details/widgets/details_app_bar.dart';
import 'package:week6/features/movei_details/widgets/movie_description_section.dart';
import 'package:week6/features/movei_details/widgets/movie_info_section.dart';
import 'package:week6/features/movei_details/widgets/movie_poster_section.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDeatilsCubit>().getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DetailsAppBar(),
            verticalSpace(24),
            BlocBuilder<MovieDeatilsCubit, MovieDeatilsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  success: (data) => Column(
                    children: [
                      MoviePosterSection(posterUrl: data.posterPath ?? ''),
                      verticalSpace(24),
                      MovieInfoSection(
                        title: data.title ?? '',
                        rating: data.voteAverage ?? 0,
                        genre:
                            data.genres?.map((e) => e.name ?? '').join(', ') ??
                            '',
                      ),
                      verticalSpace(32),
                      MovieDescriptionSection(description: data.overview ?? ''),
                      verticalSpace(32),
                    ],
                  ),
                  error: (error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          verticalSpace(16),
                          Text(
                            'Error: ${error.message}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          verticalSpace(16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MovieDeatilsCubit>().getMovieDetails(
                                widget.movieId,
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
