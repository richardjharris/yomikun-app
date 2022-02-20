import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yomikun/history/search_history/models/search_history_item.dart';
import 'package:yomikun/search/models.dart';

/// Locally-persistent search history store.
class SearchHistoryService {
  final Box<SearchHistoryItem> _box;

  static const hiveBox = 'search_history';

  SearchHistoryService() : _box = Hive.box(hiveBox);

  Timer? _debouncedHistorySaver;

  void addHistory(Query query) async {
    if (query.text == '') {
      return;
    }
    final item = SearchHistoryItem.now(query);
    _box.add(item);
  }

  /// Record history, but if multiple events are submitted in quick succession,
  /// only record the latest one.
  void addHistoryDebounced(Query query, [int debounceMs = 1000]) async {
    _debouncedHistorySaver?.cancel();
    _debouncedHistorySaver = Timer(Duration(milliseconds: debounceMs), () {
      addHistory(query);
    });
  }

  /// Return a list of all search history items, ordered in reverse
  /// chronological order.
  List<SearchHistoryItem> getHistory() {
    return _box.values.toList().reversed.toList();
  }

  /// Return a stream of all search history items.
  Stream<List<SearchHistoryItem>> watchHistory() {
    return _box.watch().map((_) => getHistory()).startWith(getHistory());
  }

  /// Clear all search history.
  Future<void> clearHistory() => _box.clear();
}
