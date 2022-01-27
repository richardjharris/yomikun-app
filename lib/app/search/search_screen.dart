import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/app/search/search_box.dart';
import 'package:yomikun/app/search/search_results.dart';

enum Commands { darkMode, bookmarks, makoto }

/// The main search page: shows the search bar, mode switch, settings icon
/// and dynamically updates search results in the body.
class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const SearchBox(),
        titleSpacing: 5,
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
      body: SearchResultsFromProvider(),
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
