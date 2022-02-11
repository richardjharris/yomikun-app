import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/app/search/search_box.dart';
import 'package:yomikun/app/search/search_results.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

enum Commands { settings, bookmarks, makoto, makotoFixed }

/// The main search page: shows the search bar, mode switch, settings icon
/// and dynamically updates search results in the body.
class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          value: Commands.settings,
                          child: Text(context.loc.settings),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                            value: Commands.bookmarks,
                            child: Text('Bookmarks')),
                        const PopupMenuItem(
                            value: Commands.makoto, child: Text('Makoto')),
                        const PopupMenuItem(
                            value: Commands.makotoFixed,
                            child: Text('Makoto (fixed)')),
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
      case Commands.settings:
        Navigator.restorablePushNamed(context, '/settings');
        break;
      case Commands.bookmarks:
        Navigator.restorablePushNamed(context, '/bookmarks');
        break;
      case Commands.makoto:
        Navigator.restorablePushNamed(context, '/makoto');
        break;
      case Commands.makotoFixed:
        Navigator.restorablePushNamed(context, '/makoto-fixed');
        break;
    }
  }
}
