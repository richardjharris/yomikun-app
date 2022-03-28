import 'package:yomikun/history/search_history/models/search_history_item.dart';

class HistoryListGroup {
  DateTime start;
  DateTime end;
  final List<SearchHistoryItem> items;

  int get itemCount => items.length;

  Duration get duration => end.difference(start);

  HistoryListGroup(this.start, this.end, this.items);

  HistoryListGroup.one(SearchHistoryItem item)
      : start = item.date,
        end = item.date,
        items = [item];

  /// Add item that occurs before all previous items chronologically.
  /// To avoid costly date comparisons, we don't verify this.
  void addEarlier(SearchHistoryItem item) {
    items.add(item);
    start = item.date;
  }
}

class GroupedHistoryList {
  List<HistoryListGroup> groups = [];

  /// Build an empty list.
  GroupedHistoryList();

  /// Build a grouped history list from a list of search history items.
  /// Items must be in descending chronological order.
  GroupedHistoryList.fromItems(List<SearchHistoryItem> items) {
    if (items.isEmpty) return;

    for (final item in items) {
      if (groups.isEmpty) {
        groups.add(HistoryListGroup.one(item));
      } else {
        // Extend existing group if history occured within 5 minutes, but
        // not allowing the total group size to be over 1 hour.
        final lastGroup = groups.last;

        if (lastGroup.start.difference(item.date).inMinutes < 5 &&
            lastGroup.duration.inMinutes < 60) {
          lastGroup.addEarlier(item);
        } else {
          // Create a new group
          groups.add(HistoryListGroup.one(item));
        }
      }
    }
  }

  /// Helper. Returns the total number of history items plus group headings.
  int get listItemCount =>
      groups.fold(0, (sum, group) => sum + group.itemCount + 1);

  /// Helper. Returns either [HistoryListGroup] (for group headings) or
  /// [SearchHistoryItem] (for history items) using indexes from 0 to
  /// [listItemCount] - 1. This can be plugged into [ListView.builder].
  ///
  /// Returns null if the index is out of range.
  dynamic listItemAt(int index) {
    for (final group in groups) {
      if (index == 0) {
        return group;
      } else if (index <= group.itemCount) {
        return group.items[index - 1];
      } else {
        index -= group.itemCount + 1;
      }
    }
    // Invalid item index.
    return null;
  }
}
