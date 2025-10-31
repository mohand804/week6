import 'package:flutter/material.dart';

mixin PaginationHandler<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  int currentPage = 1;

  void onLoadMore();
  bool get hasReachedMax;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (_shouldLoadMore()) {
        _loadMore();
      }
    });
  }

  bool _shouldLoadMore() {
    if (isLoadingMore || hasReachedMax) return false;

    final threshold = scrollController.position.maxScrollExtent - 200;
    return scrollController.position.pixels >= threshold;
  }

  void _loadMore() {
    if (!isLoadingMore && !hasReachedMax) {
      setState(() {
        isLoadingMore = true;
        currentPage++;
      });
      onLoadMore();
    }
  }

  void resetPagination() {
    setState(() {
      currentPage = 1;
      isLoadingMore = false;
    });
    scrollController.jumpTo(0);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
