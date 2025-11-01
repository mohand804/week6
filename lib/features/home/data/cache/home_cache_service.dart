import 'package:hive_flutter/hive_flutter.dart';
import 'package:week6/core/cache/hive_cache_service.dart';

import 'package:week6/features/home/data/model/movie_model.dart';

class HomeCacheService implements HiveCacheService<MovieResponse> {
  static const String moviesBoxName = 'moviesBox';
  static const String _cachedPagesOrderKey = 'cached_pages_order';
  static const int _maxCachedPages = 5;
  Box? _box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(moviesBoxName)) {
      await Hive.openBox(moviesBoxName);
    }
  }

  Box _getBox() {
    if (_box == null || !_box!.isOpen) {
      if (!Hive.isBoxOpen(moviesBoxName)) {
        throw Exception(
          'Hive box not initialized. Call HomeCacheService.init() first.',
        );
      }
      _box = Hive.box(moviesBoxName);
    }
    return _box!;
  }

  @override
  Future<void> cacheItem(String key, MovieResponse item) async {
    final box = _getBox();
    await box.put(key, item.toJson());
  }

  @override
  MovieResponse? getCachedItem(String key) {
    final box = _getBox();
    final data = box.get(key);
    if (data != null && data is Map) {
      return MovieResponse.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> clearCachedItem(String key) async {
    final box = _getBox();
    await box.delete(key);
    await _removeCachedPageKey(box, key);
  }

  @override
  Future<void> clearAll() async {
    final box = _getBox();
    await box.clear();
  }

  @override
  bool hasItem(String key) {
    final box = _getBox();
    return box.containsKey(key);
  }

  Future<void> cacheMovies(MovieResponse movies) async {
    await cacheItem('cachedMovies', movies);
  }

  MovieResponse? getCachedMovies() {
    return getCachedItem('cachedMovies');
  }

  Future<void> clearCachedMovies() async {
    await clearCachedItem('cachedMovies');
  }

  Future<void> cacheMoviesByPage(int page, MovieResponse movies) async {
    final box = _getBox();
    final key = _pageCacheKey(page);
    await box.put(key, movies.toJson());
    await _updateCachedPagesOrder(box, key);
  }

  MovieResponse? getCachedMoviesByPage(int page) {
    return getCachedItem(_pageCacheKey(page));
  }

  String _pageCacheKey(int page) => 'movies_page_$page';

  Future<void> _updateCachedPagesOrder(Box box, String key) async {
    final List<dynamic>? rawOrder = box.get(_cachedPagesOrderKey);
    final List<String> order = rawOrder != null
        ? rawOrder.map((dynamic e) => e as String).toList()
        : <String>[];

    order.remove(key);
    order.insert(0, key);

    while (order.length > _maxCachedPages) {
      final String removedKey = order.removeLast();
      await box.delete(removedKey);
    }

    await box.put(_cachedPagesOrderKey, order);
  }

  Future<void> _removeCachedPageKey(Box box, String key) async {
    final List<dynamic>? rawOrder = box.get(_cachedPagesOrderKey);
    if (rawOrder == null) return;

    final List<String> order =
        rawOrder.map((dynamic e) => e as String).toList();

    if (order.remove(key)) {
      await box.put(_cachedPagesOrderKey, order);
    }
  }
}
