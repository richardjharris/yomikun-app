import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/screens/browse_screen.dart';
import 'package:yomikun/screens/detail_screen.dart';
import 'package:yomikun/screens/search/search_screen.dart';

/// TODO: This can go away once riverpod 3 is out
class SearchResults extends ConsumerStatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  QueryResult? previousQueryResult;

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(queryResultProvider);
    return searchResults.when(data: (result) {
      previousQueryResult = result;
      return SearchResultInner(result: result);
    }, loading: () {
      if (previousQueryResult != null) {
        return SearchResultInner(result: previousQueryResult!);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }, error: (e, _) {
      previousQueryResult = null;
      return Text('Error: $e', style: const TextStyle(color: Colors.red));
    });
  }
}

class SearchResultInner extends StatelessWidget {
  const SearchResultInner({
    Key? key,
    required this.result,
  }) : super(key: key);

  final QueryResult result;

  @override
  Widget build(BuildContext context) {
    switch (result.mode) {
      case QueryMode.mei:
      case QueryMode.sei:
        return DetailScreen(query: result);
      case QueryMode.wildcard:
        return BrowseScreen(results: result.results.toList());
      default:
        return Text("Error: unknown mode '${result.mode}'",
            style: const TextStyle(color: Colors.red));
    }
  }
}
