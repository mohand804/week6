import 'package:hive_flutter/hive_flutter.dart';
import 'package:week6/core/cache/hive_cache_service.dart';

import 'package:week6/features/home/data/model/movie_model.dart';

class HomeCacheService implements HiveCacheService<MovieResponse> {
  static const String moviesBoxName = 'moviesBox';
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
    await cacheItem('movies_page_$page', movies);
  }

  MovieResponse? getCachedMoviesByPage(int page) {
    return getCachedItem('movies_page_$page');
  }
}
