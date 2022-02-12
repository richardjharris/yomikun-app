import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yomikun/bookmarks/models/bookmark.dart';

enum BookmarkSortMode { none, title, newestFirst, oldestFirst }

/// Locally-persistent bookmark store.
/// Bookmarks are represented as URLs (~routes) and titles.
class BookmarkDatabase extends ChangeNotifier {
  final Box<Bookmark> _box;

  static const hiveBox = 'bookmarks';

  BookmarkDatabase() : _box = Hive.box(hiveBox);

  /// Return a stream that emits the list of all bookmarks.
  Stream<List<Bookmark>> watchBookmarkList(
      {BookmarkSortMode sortMode = BookmarkSortMode.none}) {
    return _box.watch().map((_) {
      return getBookmarks(sortMode: sortMode);
    }).startWith(getBookmarks(sortMode: sortMode));
  }

  /// Add a bookmark by URL
  Future<void> addBookmark(String url, String title) async {
    _box.put(
        url,
        Bookmark(
          url: url,
          title: title,
          dateAdded: DateTime.now(),
        ));
    notifyListeners();
  }

  /// Remove a bookmark by URL
  Future<void> removeBookmark(String url) async {
    await _box.delete(url);
    notifyListeners();
  }

  /// Toggle the bookmarked status of this URL
  Future<void> toggleBookmark(String url, String titleIfAdded) {
    if (isBookmarked(url)) {
      return removeBookmark(url);
    } else {
      return addBookmark(url, titleIfAdded);
    }
  }

  /// Return the bookmark for the given URL, if it exists.
  Bookmark? getBookmark(String url) {
    return _box.get(url);
  }

  /// Return true if the given URL is bookmarked.
  bool isBookmarked(String url) {
    return _box.containsKey(url);
  }

  /// Return all bookmarks as a list
  List<Bookmark> getBookmarks(
      {BookmarkSortMode sortMode = BookmarkSortMode.none}) {
    var bookmarks = _box.values.toList();
    print(bookmarks);

    switch (sortMode) {
      case BookmarkSortMode.none:
        break;
      case BookmarkSortMode.title:
        bookmarks.sortBy((item) => item.title);
        break;
      case BookmarkSortMode.newestFirst:
        bookmarks.sortBy((item) => item.dateAdded);
        bookmarks = bookmarks.reversed.toList();
        break;
      case BookmarkSortMode.oldestFirst:
        bookmarks.sortBy((item) => item.dateAdded);
        break;
    }

    return bookmarks;
  }
}
