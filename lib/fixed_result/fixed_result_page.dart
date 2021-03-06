import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/navigation/open_search_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/widgets/search_results.dart';

/// Displays saved search results, e.g. from bookmarks or history.
///
/// Unlike the SearchPage (which has a search box and responds to the global
/// search text / query mode) this widget has its own fixed Query object with
/// a Back button, e.g. to go back to the bookmark or history page.
///
/// The user can also click the search icon to open the [SearchPage] with the
/// same query, and then modify the search query or issue a new one.
class FixedResultPage extends HookConsumerWidget {
  final Query query;

  const FixedResultPage({required this.query});

  static const routeName = '/result';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${query.text} (${queryModeToIcon(query.mode, context)})"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                openSearchPage(context, ref, query);
              },
            ),
          ),
        ],
      ),
      body: _SearchResultsArea(query),
    );
  }
}

class _SearchResultsArea extends HookConsumerWidget {
  final Query query;

  const _SearchResultsArea(this.query);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(queryResultProvider(query));
    return result.when(
      data: (data) => SearchResults(result: data),
      loading: () => const LoadingBox(),
      error: (error, trace) => ErrorBox(error, trace),
    );
  }
}
