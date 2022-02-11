import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/providers/search_providers.dart';
import 'package:yomikun/models/query_mode.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/app/browse/browse_page.dart';
import 'package:yomikun/app/details/details_page.dart';

final searchBoxQueryResultProvider = FutureProvider<QueryResult>((ref) async {
  /// Listen to the search box result
  final query = await ref.watch(queryProvider.future);
  return ref.watch(queryResultProvider(query).future);
});

class SearchResultsFromProvider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchBoxQueryResultProvider);
    return searchResults.when(
      data: (result) => Stack(alignment: Alignment.topCenter, children: [
        if (searchResults.isRefreshing) ...[
          const LinearProgressIndicator(color: Colors.orange),
        ],
        SearchResults(result: result),
      ]),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _stacktrace) => Text('$error'),
    );
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
        return DetailsPage(query: result);
      case QueryMode.wildcard:
        return BrowsePage(results: result.results.toList());
      default:
        return Text("Error: unknown mode '${result.mode}'",
            style: const TextStyle(color: Colors.red));
    }
  }
}
