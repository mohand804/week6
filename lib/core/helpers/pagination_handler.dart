import 'package:flutter/material.dart';

mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;
  bool get canLoadMore;
  void onLoadMore();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (_isLoadingMore || !canLoadMore) return;

    final threshold = scrollController.position.maxScrollExtent - 200;
    if (scrollController.position.pixels >= threshold) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() => _isLoadingMore = true);
    onLoadMore();
  }

  void setLoadingComplete() {
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
