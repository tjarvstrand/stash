import 'package:stash/src/api/cache_stat.dart';
import 'package:stash/src/api/eviction/eviction_policy.dart';

/// Counts how often an item is needed. Those that are used least often are discarded first.
/// This works very similar to LRU except that instead of storing the value of how recently a block was accessed,
/// we store the value of how many times it was accessed. So of course while running an access sequence we will
/// replace a entry which was used least number of times from our cache. E.g., if A was used (accessed) 5 times
/// and B was used 3 times and others C and D were used 10 times each, we will replace B. This algorithm uses
/// the [CacheStat.hitCount] to keep track of how many times a entry was uses.
class LfuEvictionPolicy extends EvictionPolicy {
  /// Builds a [LfuEvictionPolicy]
  const LfuEvictionPolicy();

  @override
  CacheStat select(Iterable<CacheStat> entries, CacheStat justAdded) {
    var selectedEntry;
    for (var entry in entries) {
      if (entry != null &&
          (selectedEntry == null || entry.hitCount < selectedEntry.hitCount) &&
          justAdded.key != entry.key) {
        selectedEntry = entry;
      }
    }

    return selectedEntry;
  }
}
