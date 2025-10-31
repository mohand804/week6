import 'package:flutter/material.dart';
import 'package:week6/features/home/data/model/movie_model.dart';
import 'package:week6/features/home/widgets/movies_list_view_item.dart';

class MoviesListView extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const MoviesListView({
    super.key,
    required this.movies,
    required this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return MoviesListViewItem(movie: movies[index]);
      },
    );
  }
}
