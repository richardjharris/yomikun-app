import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/components/search_box.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query.dart';
import 'package:yomikun/models/query_mode.dart';
import 'package:yomikun/providers.dart';
import 'package:yomikun/screens/browse_screen.dart';
import 'package:yomikun/screens/detail_screen.dart';
import 'package:yomikun/services/name_repository.dart';

final searchTextProvider = StateProvider<String>((_) => '');
final queryModeProvider = StateProvider<QueryMode>((_) => QueryMode.mei);

/// When search text or query mode changes, refresh the search results
final searchResultsProvider = FutureProvider((ref) async {
  final searchText = ref.watch(searchTextProvider);
  final queryMode = ref.watch(queryModeProvider);
  final database = ref.watch(databaseProvider);

  return performSearch(database, searchText, queryMode);
});

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeThemeIcon = Theme.of(context).brightness == Brightness.dark
        ? Icons.wb_sunny // sun
        : Icons.brightness_2; // moon

    return Scaffold(
      appBar: AppBar(
        title: const SearchBox(),
        actions: <Widget>[
          IconButton(
              icon: Icon(changeThemeIcon),
              onPressed: () => _onToggleThemeTap(context)),
        ],
      ),
      body: SearchResults(),
    );
  }

  void _onToggleThemeTap(BuildContext context) {
    EasyDynamicTheme.of(context)
        .changeTheme(dark: Theme.of(context).brightness != Brightness.dark);
  }
}

class SearchBox extends HookConsumerWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final searchText = ref.watch(searchTextProvider);
    final queryMode = ref.watch(queryModeProvider);
    return SearchBoxInner(
      queryMode: queryMode,
      onSearchTextChanged: (text) =>
          ref.read(searchTextProvider.notifier).state = text!,
      onQueryModeChanged: (mode) =>
          ref.read(queryModeProvider.notifier).state = mode!,
    );
  }
}

class SearchResults extends ConsumerStatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  Query? previousQuery;

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    return searchResults.when(data: (query) {
      previousQuery = query;
      return SearchResultInner(query: query);
    }, loading: () {
      if (previousQuery != null) {
        return SearchResultInner(query: previousQuery!);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }, error: (e, _) {
      previousQuery = null;
      return Text('Error: $e', style: const TextStyle(color: Colors.red));
    });
  }
}

class SearchResultInner extends StatelessWidget {
  const SearchResultInner({
    Key? key,
    required this.query,
  }) : super(key: key);

  final Query query;

  @override
  Widget build(BuildContext context) {
    switch (query.mode) {
      case QueryMode.mei:
      case QueryMode.sei:
        return DetailScreen(query: query);
      case QueryMode.browse:
        return BrowseScreen(results: query.results.toList());
      default:
        return Text("Error: unknown mode '${query.mode}'",
            style: const TextStyle(color: Colors.red));
    }
  }
}

/// Interpret query as kaki/yomi based on its contents.
KakiYomi guessKY(String query) {
  return query.contains(RegExp(r'\p{Script=Han}', unicode: true))
      ? KakiYomi.kaki
      : KakiYomi.yomi;
}

/// Perform a search for results using the specified query mode.
Future<Query> performSearch(
    NameRepository db, String query, QueryMode mode) async {
  query = query.trim();

  // Strip trailing romaji from the search query, which appears while the user
  // is typing a new kana or kanji via IME.
  if (query.contains(RegExp(
      r'[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]',
      unicode: true))) {
    query =
        query.replaceAll(RegExp(r'[\u{FF21}-\u{FF5A}]$', unicode: true), '');
  }

  KakiYomi? ky;
  List<NameData> results;
  NamePart? part;
  switch (mode) {
    case QueryMode.mei:
      // Assume kaki form if the name contains kanji
      ky = guessKY(query);
      results = (await db.getResults(query, NamePart.mei, ky)).toList();
      part = NamePart.mei;
      break;
    case QueryMode.sei:
      // Assume kaki form if the name contains kanji
      ky = guessKY(query);
      results = (await db.getResults(query, NamePart.sei, ky)).toList();
      part = NamePart.sei;
      break;
    case QueryMode.browse:
      results = (await db.search(query)).toList();
      break;
    default:
      return Future.error("Unknown mode: $mode");
  }

  var q = Query(mode: mode, query: query, results: results, part: part, ky: ky);
  return Future.value(q);
}
