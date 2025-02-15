import 'package:matcher/matcher.dart';
import 'package:stash/src/api/cache_entry.dart';
import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/cache_store.dart';
import 'package:stash/src/memory/memory_store.dart';
import 'package:time/time.dart';

import 'harness.dart';

/// The default cache name
const _DefaultCache = 'test';

/// Creates a new [MemoryStore]
///
/// Returns a new [MemoryStore]
Future<MemoryStore> newMemoryStore() {
  return Future.value(MemoryStore());
}

/// Deletes a [MemoryStore]
///
/// * [store]: The [MemoryStore] to delete
Future<void> deleteMemoryStore(MemoryStore store) {
  return store.deleteAll();
}

/// Calls [CacheStore.size] with a optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling size on the provided [CacheStore]
Future<int> _size(CacheStore store, {String name = _DefaultCache}) {
  return store.size(name);
}

/// Calls [CacheStore.containsKey] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [key]: The cache key
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling containsKey on the provided [CacheStore]
Future<bool> _containsKey(CacheStore store, String key,
    {String name = _DefaultCache}) {
  return store.containsKey(name, key);
}

/// Calls [CacheStore.getStat] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [key]: The cache key
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling getStat on the provided [CacheStore]
Future<CacheStat?> _getStat(CacheStore store, String key,
    {String name = _DefaultCache}) {
  return store.getStat(name, key);
}

/// Calls [CacheStore.getEntry] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [key]: The cache key
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling getEntry on the provided [CacheStore]
Future<CacheEntry?> _getEntry(CacheStore store, String key,
    {String name = _DefaultCache}) {
  return store.getEntry(name, key);
}

/// Calls [CacheStore.putEntry] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [key]: The cache key
/// * [entry]: The [CacheEntry] to store
/// * [name]: An optional cache name, assigned a default value if not provided
Future<void> _putEntry(CacheStore store, String key, CacheEntry entry,
    {String name = _DefaultCache}) {
  return store.putEntry(name, key, entry);
}

/// Calls [CacheStore.putEntry] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [generator]: The [ValueGenerator] to use
/// * [seed]: The seed for the [ValueGenerator]
/// * [name]: An optional cache name, assigned a default value if not provided
/// * [key]: The cache key
/// * [expiryTime]: The cache expiry time
/// * [creationTime]: The cache creation time
/// * [accessTime]: The cache accessTime
/// * [updateTime]: The cache update time
/// * [hitCount]: The cache hit count
///
/// Returns the created [CacheEntry]
Future<CacheEntry> _putGetEntry(
    CacheStore store, ValueGenerator generator, int seed,
    {String name = _DefaultCache,
    String? key,
    DateTime? expiryTime,
    DateTime? creationTime,
    DateTime? accessTime,
    DateTime? updateTime,
    int? hitCount}) async {
  final entry = newEntry(generator, seed,
      key: key,
      expiryTime: expiryTime,
      creationTime: creationTime,
      accessTime: accessTime,
      updateTime: updateTime,
      hitCount: hitCount);
  return _putEntry(store, entry.key, entry, name: name).then((v) => entry);
}

/// Calls [CacheStore.remove] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [key]: The cache key
/// * [name]: An optional cache name, assigned a default value if not provided
Future<void> _remove(CacheStore store, String key,
    {String name = _DefaultCache}) {
  return store.remove(name, key);
}

/// Calls [CacheStore.keys] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling keys on the provided [CacheStore]
Future<Iterable<String>> _keys(CacheStore store,
    {String name = _DefaultCache}) {
  return store.keys(name);
}

/// Calls [CacheStore.stats] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling stats on the provided [CacheStore]
Future<Iterable<CacheStat?>> _stats(CacheStore store,
    {String name = _DefaultCache}) {
  return store.stats(name);
}

/// Calls [CacheStore.values] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
///
/// Returns the result of calling values on the provided [CacheStore]
Future<Iterable<CacheEntry?>> _values(CacheStore store,
    {String name = _DefaultCache}) {
  return store.values(name);
}

/// Calls [CacheStore.clear] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
Future<void> _clear(CacheStore store, {String name = _DefaultCache}) {
  return store.clear(name);
}

/// Calls [CacheStore.delete] with an optional cache name
///
/// * [store]: The [CacheStore]
/// * [name]: An optional cache name, assigned a default value if not provided
Future<void> _delete(CacheStore store, {String name = _DefaultCache}) {
  return store.delete(name);
}

/// Test that adds a new entry on the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeAddEntry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry = await _putGetEntry(store, ctx.generator, 1);
  final hasEntry = await _containsKey(store, entry.key);
  check(ctx, hasEntry, isTrue, '_storeAddEntry_1');

  return store;
}

/// Test that adds and fetches a entry from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeAddGetEntry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  final entry2 = await _getEntry(store, entry1.key);

  check(ctx, entry2, entry1, '_storeAddGetEntry_1');

  return store;
}

/// Test that removes a entry from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeRemoveEntry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  var hasEntry = await _containsKey(store, entry1.key);
  check(ctx, hasEntry, isTrue, '_storeRemoveEntry_1');

  await _remove(store, entry1.key);
  hasEntry = await _containsKey(store, entry1.key);
  check(ctx, hasEntry, isFalse, '_storeRemoveEntry_2');

  return store;
}

/// Test that gets the size of the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeSize<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  var size = await _size(store);
  check(ctx, size, 0, '_storeSize_1');

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  size = await _size(store);
  check(ctx, size, 1, '_storeSize_2');

  final entry2 = await _putGetEntry(store, ctx.generator, 2);
  size = await _size(store);
  check(ctx, size, 2, '_storeSize_3');

  await _remove(store, entry1.key);
  size = await _size(store);
  check(ctx, size, 1, '_storeSize_4');

  await _remove(store, entry2.key);
  size = await _size(store);
  check(ctx, size, 0, '_storeSize_5');

  return store;
}

/// Test that clears the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeClear<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx.generator, 1, name: 'cache1');
  await _putGetEntry(store, ctx.generator, 2, name: 'cache1');
  var size = await _size(store, name: 'cache1');
  check(ctx, size, 2, '_storeClear_1');

  await _putGetEntry(store, ctx.generator, 1, name: 'cache2');
  await _putGetEntry(store, ctx.generator, 2, name: 'cache2');
  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeClear_2');

  await _clear(store, name: 'cache1');
  size = await _size(store, name: 'cache1');
  check(ctx, size, 0, '_storeClear_3');

  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeClear_4');

  return store;
}

/// Test that deletes a store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeDelete<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  await _putGetEntry(store, ctx.generator, 1, name: 'cache1');
  await _putGetEntry(store, ctx.generator, 2, name: 'cache1');
  var size = await _size(store, name: 'cache1');
  check(ctx, size, 2, '_storeDelete_1');

  await _putGetEntry(store, ctx.generator, 1, name: 'cache2');
  await _putGetEntry(store, ctx.generator, 2, name: 'cache2');
  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeDelete_2');

  await _delete(store, name: 'cache1');
  size = await _size(store, name: 'cache1');
  check(ctx, size, 0, '_storeDelete_3');

  size = await _size(store, name: 'cache2');
  check(ctx, size, 2, '_storeDelete_4');

  return store;
}

/// Test that gets the [CacheStat] from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeGetStat<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry = await _putGetEntry(store, ctx.generator, 1);
  final stat = await _getStat(store, entry.key);

  check(ctx, stat, isNotNull, '_storeGetStat_1');
  check(ctx, stat?.key, entry.key, '_storeGetStat_2');
  check(ctx, stat?.expiryTime, entry.expiryTime, '_storeGetStat_3');
  check(ctx, stat?.creationTime, entry.creationTime, '_storeGetStat_4');
  check(ctx, stat?.accessTime, entry.accessTime, '_storeGetStat_5');
  check(ctx, stat?.updateTime, entry.updateTime, '_storeGetStat_6');

  return store;
}

/// Test that changes a store entry
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeChangeEntry<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);

  final oldAccessTime = entry1.accessTime;
  final oldHitCount = entry1.hitCount;
  entry1.accessTime = 1.minutes.fromNow;
  entry1.hitCount++;
  await _putEntry(store, entry1.key, entry1);

  final entry2 = await _getEntry(store, entry1.key);
  check(ctx, entry2?.expiryTime, equals(entry1.expiryTime),
      '_storeChangeEntry_1');
  check(ctx, entry2?.creationTime, equals(entry1.creationTime),
      '_storeChangeEntry_2');
  check(ctx, entry2?.accessTime, isNot(equals(oldAccessTime)),
      '_storeChangeEntry_3');
  check(ctx, entry2?.accessTime, equals(entry1.accessTime),
      '_storeChangeEntry_4');
  check(ctx, entry2?.updateTime, equals(entry1.updateTime),
      '_storeChangeEntry_5');
  check(
      ctx, entry2?.hitCount, isNot(equals(oldHitCount)), '_storeChangeEntry_6');
  check(ctx, entry2?.hitCount, equals(entry1.hitCount), '_storeChangeEntry_7');

  return store;
}

/// Test that retrieves the keys from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeKeys<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  final entry2 = await _putGetEntry(store, ctx.generator, 2);
  final keys = await _keys(store);

  check(ctx, keys, containsAll([entry1.key, entry2.key]), '_storeKeys_1');

  return store;
}

/// Test that retrieves the values from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeValues<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  final entry2 = await _putGetEntry(store, ctx.generator, 2);
  final values = await _values(store);

  check(ctx, values, containsAll([entry1, entry2]), '_storeValues_1');

  return store;
}

/// Test that retrieves the stats from the store
///
/// * [ctx]: The test context
///
/// Return the created store
Future<T> _storeStats<T extends CacheStore>(TestContext<T> ctx) async {
  final store = await ctx.newStore();

  final entry1 = await _putGetEntry(store, ctx.generator, 1);
  final entry2 = await _putGetEntry(store, ctx.generator, 2);
  final stats = await _stats(store);

  check(ctx, stats, containsAll([entry1.stat, entry2.stat]), '_storeStats_1');

  return store;
}

/// returns the list of tests to execute
List<Future<T> Function(TestContext<T>)> _getTests<T extends CacheStore>() {
  return [
    _storeAddEntry,
    _storeAddGetEntry,
    _storeRemoveEntry,
    _storeSize,
    _storeClear,
    _storeDelete,
    _storeGetStat,
    _storeChangeEntry,
    _storeKeys,
    _storeValues,
    _storeStats
  ];
}

/// Entry point for the store testing harness. It delegates most of the
/// construction to user provided functions that are responsible for the
/// [CacheStore] creation, and the generation of testing values (with a provided
/// [ValueGenerator] instance). They are encapsulated in provided [TestContext] object
///
/// * [ctx]: the test context
Future<void> testStoreWith<T extends CacheStore>(TestContext<T> ctx) async {
  for (var test in _getTests<T>()) {
    await test(ctx).then(ctx.deleteStore);
  }
}
