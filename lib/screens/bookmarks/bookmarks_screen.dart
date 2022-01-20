import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/providers/bookmark_providers.dart';

// Bookmark provider: uses Hive to monitor the 'bookmarks' key, which holds all
// bookmarks.

class BookmarksScreen extends HookConsumerWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: bookmarks.when(
            data: (data) => bookmarkList(data),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(
                  child: Text('Error: $e'),
                )));
  }

  Widget bookmarkList(BookmarkList bookmarks) {
    List items = bookmarks.allBookmarks().toList();
    if (items.isEmpty) {
      return noBookmarks();
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final Bookmark bookmark = items[index];
        return ListTile(
          title: Text(bookmark.code),
        );
      },
    );
  }

  Widget noBookmarks() {
    return Container(
      margin: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const Text(
          'You have no bookmarks. To bookmark a name, slide it to the left and select "Bookmark"',
          textAlign: TextAlign.center),
    );
  }
}
