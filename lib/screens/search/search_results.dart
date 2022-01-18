import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/screens/browse_screen.dart';
import 'package:yomikun/screens/detail_screen.dart';
import 'package:yomikun/screens/search/search_box.dart';

final searchBoxQueryResultProvider = FutureProvider<QueryResult>((ref) async {
  /// Listen to the search box result
  final query = await ref.watch(queryProvider.future);
  return ref.watch(queryResultProvider(query).future);
});

/// TODO: This can go away once riverpod 3 is out
class SearchResultsFromProvider extends ConsumerStatefulWidget {
  @override
  _SearchResultsFromProviderState createState() =>
      _SearchResultsFromProviderState();
}

class _SearchResultsFromProviderState
    extends ConsumerState<SearchResultsFromProvider> {
  QueryResult? previousQueryResult;

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchBoxQueryResultProvider);
    return searchResults.when(data: (result) {
      previousQueryResult = result;
      return SearchResults(result: result);
    }, loading: () {
      if (previousQueryResult != null) {
        return SearchResults(result: previousQueryResult!);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }, error: (error, trace) {
      previousQueryResult = null;
      print(trace);
      return Text('Error: $error', style: const TextStyle(color: Colors.red));
    });
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
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
