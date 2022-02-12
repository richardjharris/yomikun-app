import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

import 'models/bookmark.dart';

final bookmarkSortModeProvider = Provider((_) => BookmarkSortMode.newestFirst);
final bookmarkListProvider = StreamProvider((ref) {
  final sortMode = ref.watch(bookmarkSortModeProvider);
  final bookmarkDatabase = ref.watch(bookmarkDatabaseProvider);
  return bookmarkDatabase.watchBookmarkList(sortMode: sortMode);
});

/// Shows the list of bookmarks and allows them to be visited or deleted
class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  static const routeName = '/bookmarks';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkListStream = ref.watch(bookmarkListProvider);
    print(bookmarkListStream);

    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.bookmarks),
        ),
        body: bookmarkListStream.when(
          data: (data) => _bookmarkList(context, ref, data),
          loading: () => const LoadingBox(),
          error: (e, stack) => ErrorBox(e, stack),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await ref
                .read(bookmarkDatabaseProvider)
                .addBookmark("/makoto", "Makoto");
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget _bookmarkList(
      BuildContext context, WidgetRef ref, List<Bookmark> items) {
    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noBookmarksMessage);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final Bookmark bookmark = items[index];
        return ListTile(
          title: Text(bookmark.title),
          subtitle: Text(bookmark.url),
          trailing: IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => _deleteBookmark(ref, bookmark),
          ),
        );
      },
    );
  }

  void _deleteBookmark(WidgetRef ref, Bookmark bookmark) {
    ref.read(bookmarkDatabaseProvider).removeBookmark(bookmark.url);
  }
}
