// Hive box

import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_result.dart';

const hiveBoxName = 'yomikun_hive';
const hiveBookmarksKey = 'bookmarks';

// Opens the main Hive box
final hiveBoxProvider = Provider((_) {
  print('getting box $hiveBoxName');
  return Hive.box(hiveBoxName);
});

// Watches the bookmarks key and builds an LinkedHashMap of all bookmarks.
final bookmarksProvider = StreamProvider.autoDispose<BookmarkList>(
  (ref) {
    final box = ref.watch(hiveBoxProvider);
    return box.watch(key: hiveBookmarksKey).map((event) {
      print("got event: $event");
      return BookmarkList.fromHiveData(event.value ?? {});
    }).startWith(BookmarkList.empty());
  },
);

/// Add a bookmark to the bookmark set
void addBookmark(Box box, Bookmark bookmark) {
  List<String> bookmarks = box.get(hiveBookmarksKey, defaultValue: []);
  bookmarks.add(bookmark.code);
  box.put(hiveBookmarksKey, bookmarks);
}

// Remove a bookmark from the bookmark set
void removeBookmark(Box box, Bookmark bookmark) {
  List<String> bookmarks = box.get(hiveBookmarksKey, defaultValue: []);
  bookmarks.remove(bookmark.code);
  box.put(hiveBookmarksKey, bookmarks);
}

class Bookmark {
  final String _code;

  Bookmark(this._code);

  get code => _code;

  factory Bookmark.resultPage(String query, QueryMode mode) {
    return Bookmark(
      'resultPage|$query|${mode.name}',
    );
  }

  factory Bookmark.nameEntry(NameData data) {
    return Bookmark(
      'nameEntry|${data.key()}',
    );
  }
}

class BookmarkList {
  final LinkedHashMap<String, void> _bookmarks;

  BookmarkList(this._bookmarks);

  factory BookmarkList.empty() {
    return BookmarkList(LinkedHashMap());
  }

  factory BookmarkList.fromHiveData(List<String> data) {
    return BookmarkList(
        LinkedHashMap.fromEntries(data.map((v) => MapEntry(v, null))));
  }

  bool hasBookmark(Bookmark bookmark) {
    return _bookmarks.containsKey(bookmark.code);
  }

  Iterable<Bookmark> allBookmarks() {
    return _bookmarks.keys.map((b) => Bookmark(b));
  }
}
