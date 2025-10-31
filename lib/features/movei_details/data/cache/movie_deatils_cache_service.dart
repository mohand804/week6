import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:week6/features/movei_details/data/model/movie_deatils_model.dart';
import 'package:week6/core/cache/hive_cache_service.dart';

class MovieDetailsCacheService implements HiveCacheService<MovieDetailsModel> {
  static const String movieDetailsBoxName = 'movieDetailsBox';
  static const String timestampsBoxName = 'movieDetailsTimestamps';

  static const Duration cacheValidDuration = Duration(hours: 24);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(movieDetailsBoxName)) {
      await Hive.openBox<String>(movieDetailsBoxName);
    }
    if (!Hive.isBoxOpen(timestampsBoxName)) {
      await Hive.openBox<int>(timestampsBoxName);
    }
  }

  @override
  Future<void> cacheItem(String key, MovieDetailsModel item) async {
    final box = Hive.box<String>(movieDetailsBoxName);
    final timestampsBox = Hive.box<int>(timestampsBoxName);

    final jsonString = jsonEncode(item.toJson());
    await box.put(key, jsonString);
    await timestampsBox.put(key, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  MovieDetailsModel? getCachedItem(String key) {
    final box = Hive.box<String>(movieDetailsBoxName);
    final timestampsBox = Hive.box<int>(timestampsBoxName);

    if (!box.containsKey(key)) return null;

    final timestamp = timestampsBox.get(key);
    if (timestamp == null) {
      final jsonString = box.get(key);
      if (jsonString == null) return null;
      return MovieDetailsModel.fromJson(jsonDecode(jsonString));
    }

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final age = DateTime.now().difference(cachedTime);

    if (age > cacheValidDuration) {
      box.delete(key);
      timestampsBox.delete(key);
      return null;
    }

    final jsonString = box.get(key);
    if (jsonString == null) return null;
    return MovieDetailsModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> clearCachedItem(String key) async {
    final box = Hive.box<String>(movieDetailsBoxName);
    final timestampsBox = Hive.box<int>(timestampsBoxName);

    await box.delete(key);
    await timestampsBox.delete(key);
  }

  @override
  Future<void> clearAll() async {
    final box = Hive.box<String>(movieDetailsBoxName);
    final timestampsBox = Hive.box<int>(timestampsBoxName);

    await box.clear();
    await timestampsBox.clear();
  }

  @override
  bool hasItem(String key) {
    final box = Hive.box<String>(movieDetailsBoxName);
    return box.containsKey(key);
  }

  Future<void> cacheMovieDetails(
    int movieId,
    MovieDetailsModel movieDetails,
  ) async {
    await cacheItem('movie_details_$movieId', movieDetails);
  }

  MovieDetailsModel? getCachedMovieDetails(int movieId) {
    return getCachedItem('movie_details_$movieId');
  }

  Future<void> clearCachedMovieDetails(int movieId) async {
    await clearCachedItem('movie_details_$movieId');
  }
}
