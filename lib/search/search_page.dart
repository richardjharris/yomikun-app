import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/providers/search_providers.dart';
import 'package:yomikun/search/widgets/navigation_drawer.dart';
import 'package:yomikun/search/widgets/search_box.dart';
import 'package:yomikun/search/widgets/search_results.dart';

final searchBoxQueryResultProvider = FutureProvider<QueryResult>((ref) async {
  /// Listen to the search box result
  final query = await ref.watch(queryProvider.future);
  return ref.watch(queryResultProvider(query).future);
});

/// The main search page: shows the search bar, mode switch, settings menu icon
/// and dynamically updates search results in the body.
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const SearchBox(),
        titleSpacing: 5,
      ),
      body: _SearchResultsFromProvider(),
    );
  }
}

/// Shows search results based on query result provider.
class _SearchResultsFromProvider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchBoxQueryResultProvider);
    return searchResults.when(
      data: (result) => Stack(alignment: Alignment.topCenter, children: [
        SearchResults(result: result),
        if (searchResults.isRefreshing) ...[
          const LinearProgressIndicator(color: Colors.orange),
        ],
      ]),
      loading: () => const LoadingBox(),
      error: (error, stack) => ErrorBox(error, stack),
    );
  }
}
