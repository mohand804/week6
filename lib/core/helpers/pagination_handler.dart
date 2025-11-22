class PaginationHandler<T> {
  List<T> items = [];
  int currentPage = 0;
  int? totalPages;
  bool isLoadingMore = false;
  bool hasError = false;

  bool get hasMorePages {
    if (totalPages == null) return true;
    return currentPage < totalPages!;
  }

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  void startLoading() {
    isLoadingMore = true;
    hasError = false;
  }

  void addPage(List<T> newItems, int page, int total) {
    items.addAll(newItems);
    currentPage = page;
    totalPages = total;
    isLoadingMore = false;
    hasError = false;
  }

  void reset() {
    items = [];
    currentPage = 0;
    totalPages = null;
    isLoadingMore = false;
    hasError = false;
  }

  int get nextPage => currentPage + 1;
}
 