import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/name_list/name_list_page.dart';
import 'package:yomikun/name_person/name_person_page.dart';
import 'package:yomikun/search/providers/search_providers.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/search/models.dart';

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

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.result,
  }) : super(key: key);

  final QueryResult result;

  @override
  Widget build(BuildContext context) {
    if (result.text.isEmpty) {
      return const PlaceholderMessage('Enter a name in kanji or kana');
    }

    switch (result.mode) {
      case QueryMode.mei:
      case QueryMode.sei:
        return NameBreakdownPage(query: result);
      case QueryMode.wildcard:
        return NameListPage(results: result.results.toList());
      case QueryMode.person:
        return NamePersonPage(query: result);
      default:
        return ErrorBox("Unknown mode '${result.mode}'");
    }
  }
}
