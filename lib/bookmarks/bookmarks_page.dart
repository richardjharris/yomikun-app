import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:yomikun/core/providers/core_providers.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkListStream = ref.watch(bookmarkListProvider);
    print(bookmarkListStream);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: bookmarkListStream.when(
            data: (data) => _bookmarkList(ref, data),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(
                  child: Text('Error: $e'),
                )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await ref
                .read(bookmarkDatabaseProvider)
                .addBookmark("/makoto", "Makoto");
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget _bookmarkList(WidgetRef ref, List<Bookmark> items) {
    if (items.isEmpty) {
      return _noBookmarks();
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

  Widget _noBookmarks() {
    return Container(
      margin: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const Text(
          'You have no bookmarks. To bookmark a name, slide it to the left and select "Bookmark"',
          textAlign: TextAlign.center),
    );
  }
}
