import 'package:yomikun/search/models.dart';
import 'package:collection/collection.dart';

/// Cached Query result data, so we don't do repeated work for all the
/// visualisations.
class CachedQueryResult {
  List<NameData> originalData;
  bool _sorted = false;

  CachedQueryResult({required List<NameData> data}) : originalData = data;

  /// Return results sorted by hitsTotal descending.
  List<NameData> sortedByHitsDescending() {
    if (!_sorted) {
      originalData.sort((a, b) => b.hitsTotal.compareTo(a.hitsTotal));
    }
    _sorted = true;
    return originalData;
  }

  /// Return results where hitsTotal > 0
  Iterable<NameData> withAtLeastOneHit() {
    return sortedByHitsDescending()
        .takeWhile((element) => element.hitsTotal > 0);
  }

  /// Total hits across all results.
  int get totalHits => withAtLeastOneHit().map((e) => e.hitsTotal).sum;

  bool get allZeroHits => totalHits == 0;
  bool get hasAtLeastOneHit => !allZeroHits;

  bool get noResults => originalData.isEmpty;
}
