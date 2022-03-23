import 'package:yomikun/core/models.dart';
import 'package:yomikun/search/models.dart';
import 'package:collection/collection.dart';

/// Cached Query result data, so we don't do repeated work for all the
/// visualisations.
class CachedQueryResult {
  List<NameData> originalData;
  bool _sorted = false;
  GenderFilter _genderFilter = GenderFilter.all;

  CachedQueryResult({required List<NameData> data}) : originalData = data;

  void setGenderFilter(GenderFilter genderFilter) {
    _genderFilter = genderFilter;
  }

  Iterable<NameData> items() {
    return originalData.where(_applyGenderFilter);
  }

  /// Return results sorted by hitsTotal descending.
  Iterable<NameData> sortedByHitsDescending() {
    if (!_sorted) {
      originalData.sort((a, b) => b.hitsTotal.compareTo(a.hitsTotal));
    }
    _sorted = true;
    return items();
  }

  /// Return results where hitsTotal > 0
  Iterable<NameData> withAtLeastOneHit() {
    return sortedByHitsDescending()
        .takeWhile((element) => element.hitsTotal > 0);
  }

  /// Total hits across all results.
  int get totalHits => withAtLeastOneHit().map((e) => e.hitsTotal).sum;

  /// Most popular entry (by hits) with a given part
  NameData? getMostPopular(NamePart part) {
    return sortedByHitsDescending().firstWhereOrNull((e) => e.part == part);
  }

  /// Remove entries not matching the filter, in-place.
  bool _applyGenderFilter(NameData item) {
    switch (_genderFilter) {
      case GenderFilter.all:
        return true;
      case GenderFilter.male:
        return item.femaleRatio <= 200;
      case GenderFilter.female:
        return item.femaleRatio >= 50;
    }
  }

  bool get allZeroHits => totalHits == 0;
  bool get hasAtLeastOneHit => !allZeroHits;

  bool get noResults => originalData.isEmpty;
}
