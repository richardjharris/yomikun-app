import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:yomikun/components/search_box.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query.dart';
import 'package:yomikun/screens/browse_screen.dart';
import 'package:yomikun/screens/detail_screen.dart';
import 'package:yomikun/services/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String _searchText = "";
  final _searchTextController = TextEditingController();
  late Future<Query> searchQuery;
  String dropdownValue = "Mei";

  SearchScreenState() {
    _searchTextController.addListener(() {
      setState(() {
        _searchText = _searchTextController.text;
        searchQuery = performSearch(_searchText, dropdownValue);
      });
    });

    // Initially load no results
    searchQuery = performSearch("裕子", "Mei");
  }

  @override
  Widget build(BuildContext context) {
    final changeThemeIcon = Theme.of(context).brightness == Brightness.dark
        ? Icons.wb_sunny // sun
        : Icons.brightness_2; // moon

    return Scaffold(
      appBar: AppBar(
        title: SearchBox(
            controller: _searchTextController,
            dropdownValue: dropdownValue,
            onDropdownValueChanged: (String? newValue) => {
                  setState(() {
                    dropdownValue = newValue!;
                    searchQuery = performSearch(_searchText, dropdownValue);
                  })
                }),
        actions: <Widget>[
          IconButton(icon: Icon(changeThemeIcon), onPressed: _onToggleThemeTap),
        ],
      ),
      body: FutureBuilder<Query>(
        future: searchQuery,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var query = snapshot.data!;
            switch (query.mode) {
              case "Mei":
                return DetailScreen(query: query);
              case "MeiKana":
                return DetailScreen(query: query);
              case "Sei":
                return DetailScreen(query: query);
              case "Browse":
                return BrowseScreen(results: query.results.toList());
              default:
                return Text("Error: unknown mode '${query.mode}'");
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void _onToggleThemeTap() {
    EasyDynamicTheme.of(context)
        .changeTheme(dark: Theme.of(context).brightness != Brightness.dark);
  }

  /// Interpret query as kaki/yomi based on its contents.
  KakiYomi guessKY(String query) {
    return query.contains(RegExp(r'\p{Script=Han}', unicode: true))
        ? KakiYomi.kaki
        : KakiYomi.yomi;
  }

  /// Perform a search for results using the specified query mode.
  Future<Query> performSearch(String query, String mode) async {
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
      case "Mei":
        // Assume kaki form if the name contains kanji
        ky = guessKY(query);
        results =
            (await NameDatabase.getResults(query, NamePart.mei, ky)).toList();
        part = NamePart.mei;
        break;
      case "Sei":
        // Assume kaki form if the name contains kanji
        ky = guessKY(query);
        results =
            (await NameDatabase.getResults(query, NamePart.sei, ky)).toList();
        part = NamePart.sei;
        break;
      case "MeiKana":
        // This mode forces mei to be interpreted as written form even if it
        // is kana-only
        results =
            (await NameDatabase.getResults(query, NamePart.mei, KakiYomi.kaki))
                .toList();
        ky = KakiYomi.kaki;
        part = NamePart.mei;
        break;
      case "Browse":
        results = (await NameDatabase.search(query)).toList();
        break;
      default:
        return Future.error("Unknown mode: $mode");
    }

    var q =
        Query(mode: mode, query: query, results: results, part: part, ky: ky);
    return Future.value(q);
  }
}
