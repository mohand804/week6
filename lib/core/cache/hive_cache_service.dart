abstract class HiveCacheService<T> {
  Future<void> cacheItem(String key, T item);

  T? getCachedItem(String key);

  Future<void> clearCachedItem(String key);

  Future<void> clearAll();

  bool hasItem(String key);
}
