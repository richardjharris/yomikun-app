import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/name_lookup.dart';
import 'package:yomikun/screens/search/search_box.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/screens/browse_screen.dart';
import 'package:yomikun/screens/detail_screen.dart';
import 'package:yomikun/screens/search/search_results.dart';

final queryResultProvider = FutureProvider<QueryResult>((ref) async {
  /// Listen to the search box result
  final query = await ref.watch(queryProvider.future);
  final db = ref.read(databaseProvider);
  return performQuery(db, query.text, query.mode);
});

enum Commands { darkMode, bookmarks, makoto }

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const SearchBox(),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton(
                  //icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => <PopupMenuEntry<Commands>>[
                        PopupMenuItem(
                          value: Commands.darkMode,
                          child: Text(isDarkMode
                              ? 'Enable light mode'
                              : 'Enable dark mode'),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                            value: Commands.bookmarks,
                            child: Text('Bookmarks')),
                        const PopupMenuItem(
                            value: Commands.makoto, child: Text('Makoto')),
                      ],
                  onSelected: (Commands command) {
                    _onCommandTap(context, command);
                  })),
        ],
      ),
      body: SearchResults(),
    );
  }

  void _onCommandTap(BuildContext context, Commands command) {
    switch (command) {
      case Commands.darkMode:
        _onToggleThemeTap(context);
        break;
      case Commands.bookmarks:
        Navigator.pushNamed(context, '/bookmarks');
        break;
      case Commands.makoto:
        Navigator.pushNamed(context, '/makoto');
        break;
    }
  }

  void _onToggleThemeTap(BuildContext context) {
    EasyDynamicTheme.of(context)
        .changeTheme(dark: Theme.of(context).brightness != Brightness.dark);
  }
}
