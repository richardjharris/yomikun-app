import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/query_list_tile.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/widgets/search_box.dart';
import 'package:yomikun/bookmarks/models/bookmark.dart';

final bookmarkSortModeProvider = Provider((_) => BookmarkSortMode.newestFirst);
final bookmarkListProvider = Provider((ref) {
  final sortMode = ref.watch(bookmarkSortModeProvider);
  final bookmarkDatabase = ref.watch(bookmarkDatabaseProvider);
  return bookmarkDatabase.getBookmarks(sortMode: sortMode);
});

/// Shows the list of bookmarks and allows them to be visited or deleted
class BookmarksPage extends HookConsumerWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  static const routeName = '/bookmarks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkListData = ref.watch(bookmarkListProvider);
    final lastDeletedBookmark = useState<Bookmark?>(null);
    final lastDeletedBookmarkId = useState<int>(0);

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(context.loc.bookmarks),
      ),
      body: _bookmarkList(
        context,
        ref,
        bookmarkListData,
        lastDeletedBookmark,
        lastDeletedBookmarkId,
      ),
    );
  }

  Widget _bookmarkList(
    BuildContext context,
    WidgetRef ref,
    List<Bookmark> items,
    ValueNotifier<Bookmark?> lastDeleted,
    ValueNotifier<int> lastDeletedId,
  ) {
    if (lastDeleted.value != null) {
      // Add deleted item back in correct position
      items = [
        ...items.take(lastDeletedId.value),
        lastDeleted.value!,
        ...items.skip(lastDeletedId.value),
      ];
    }

    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noBookmarksMessage);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final Bookmark bookmark = items[index];
            bool isDeleted = bookmark == lastDeleted.value;
            return Slidable(
              child: BookmarkListTile(
                bookmark: bookmark,
                isDeleted: isDeleted,
              ),
              groupTag: this,
              endActionPane: ActionPane(
                extentRatio: 0.4,
                motion: const ScrollMotion(),
                children: [
                  if (isDeleted)
                    SlidableAction(
                      backgroundColor: Colors.green.shade900,
                      foregroundColor: Colors.white,
                      onPressed: (context) {
                        _addBookmark(context, ref, bookmark);
                        lastDeleted.value = null;
                      },
                      icon: Icons.star_outline,
                      label: context.loc.addBookmarkAction,
                    ),
                  if (!isDeleted)
                    SlidableAction(
                      backgroundColor: Colors.green.shade900,
                      foregroundColor: Colors.white,
                      onPressed: (context) {
                        _deleteBookmark(context, ref, bookmark);
                        lastDeleted.value = bookmark;
                        lastDeletedId.value = index;
                      },
                      icon: Icons.star,
                      label: context.loc.removeBookmarkAction,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _addBookmark(BuildContext context, WidgetRef ref, Bookmark bookmark) {
    ref
        .read(bookmarkDatabaseProvider)
        .addBookmark(bookmark.url, bookmark.title, bookmark.dateAdded);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.loc.sbBookmarkAdded)));
  }

  void _deleteBookmark(BuildContext context, WidgetRef ref, Bookmark bookmark) {
    ref.read(bookmarkDatabaseProvider).removeBookmark(bookmark.url);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.loc.sbBookmarkRemoved)));
  }
}

class BookmarkListTile extends StatelessWidget {
  final Bookmark bookmark;
  final bool isDeleted;

  const BookmarkListTile(
      {Key? key, required this.bookmark, this.isDeleted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 20);
    if (isDeleted) {
      style = style.copyWith(
          decoration: TextDecoration.lineThrough, color: Colors.grey);
    }

    if (bookmark.urlAction == '/result' &&
        setEquals(bookmark.urlParameters.keys.toSet(), {'text', 'mode'})) {
      return QueryListTile(
        query: Query.fromMap(bookmark.urlParameters),
        isDeleted: isDeleted,
      );
    } else {
      final brightness = Theme.of(context).brightness;
      QueryMode? mode =
          bookmark.urlParameters['part']?.toNamePart()?.toQueryMode();

      Widget leading = mode == null
          ? const SizedBox(height: 30, width: 30)
          : Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: queryModeToColor(mode, brightness),
              ),
              child: Center(
                  child: Text(queryModeToIcon(mode),
                      style: style.copyWith(color: Colors.white),
                      locale: const Locale('ja'))),
            );

      return ListTile(
        leading: leading,
        title: Text(bookmark.title, style: style, locale: const Locale('ja')),
        // TODO enable when /name route is implemented?
        //onTap: () => _openBookmark(context, bookmark),
      );
    }
  }

  /*void _openBookmark(BuildContext context, Bookmark bookmark) {
    Navigator.of(context).restorablePushNamed(bookmark.url);
  }*/
}
