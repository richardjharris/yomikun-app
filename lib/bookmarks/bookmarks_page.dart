import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

import 'models/bookmark.dart';

final bookmarkSortModeProvider = Provider((_) => BookmarkSortMode.newestFirst);
final bookmarkListProvider = StreamProvider((ref) {
  final sortMode = ref.watch(bookmarkSortModeProvider);
  final bookmarkDatabase = ref.watch(bookmarkDatabaseProvider);
  // TODO no need for stream as databaseProvider refreshes on change.
  return bookmarkDatabase.watchBookmarkList(sortMode: sortMode);
});

/// Shows the list of bookmarks and allows them to be visited or deleted
class BookmarksPage extends HookConsumerWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  static const routeName = '/bookmarks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkListStream = ref.watch(bookmarkListProvider);
    final lastDeletedBookmark = useState<Bookmark?>(null);

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(context.loc.bookmarks),
      ),
      body: bookmarkListStream.when(
        data: (data) => _bookmarkList(
          context,
          ref,
          data,
          lastDeletedBookmark,
        ),
        loading: () => const LoadingBox(),
        error: (e, stack) => ErrorBox(e, stack),
      ),
    );
  }

  Widget _bookmarkList(
    BuildContext context,
    WidgetRef ref,
    List<Bookmark> items,
    ValueNotifier<Bookmark?> lastDeleted,
  ) {
    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noBookmarksMessage);
    }

    items = [
      if (lastDeleted.value != null) lastDeleted.value!,
      ...items,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final Bookmark bookmark = items[index];
            return Slidable(
              child: ListTile(
                title: Text(bookmark.title),
                onTap: () => _openBookmark(context, bookmark),
              ),
              groupTag: this,
              endActionPane: ActionPane(
                extentRatio: 0.4,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.green.shade900,
                    foregroundColor: Colors.white,
                    onPressed: (context) {
                      if (bookmark == lastDeleted.value) {
                        _addBookmark(ref, bookmark);
                        lastDeleted.value = null;
                      } else {
                        _deleteBookmark(ref, bookmark);
                        lastDeleted.value = bookmark;
                      }
                    },
                    icon: bookmark == lastDeleted.value
                        ? Icons.star_outline
                        : Icons.star,
                    label: bookmark == lastDeleted.value
                        ? 'Bookmark'
                        : 'Unbookmark',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openBookmark(BuildContext context, Bookmark bookmark) {
    print(bookmark.url);
    Navigator.of(context).restorablePushNamed(bookmark.url);
  }

  void _addBookmark(WidgetRef ref, Bookmark bookmark) {
    ref
        .read(bookmarkDatabaseProvider)
        .addBookmark(bookmark.url, bookmark.title);
  }

  void _deleteBookmark(WidgetRef ref, Bookmark bookmark) {
    ref.read(bookmarkDatabaseProvider).removeBookmark(bookmark.url);
  }
}
