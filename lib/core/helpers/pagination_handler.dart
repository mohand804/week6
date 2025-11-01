import 'package:flutter/material.dart';

mixin PaginationHandler<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  void onLoadMore();

  bool get isLoadingMore;

  bool get hasReachedMax;

  double get paginationThreshold => 200;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!scrollController.hasClients) return;
    if (isLoadingMore || hasReachedMax) return;

    final currentPosition = scrollController.position.pixels;
    final maxScrollExtent = scrollController.position.maxScrollExtent;

    if (currentPosition >= maxScrollExtent - paginationThreshold) {
      onLoadMore();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }
}
