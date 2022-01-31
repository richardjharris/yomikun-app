import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/models/query.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/app/search/search_results.dart';
import 'package:yomikun/routing/open_search_page.dart';

/// Displays a single search result, e.g. from bookmarks or history.
/// Unlike the SearchPage, which shows the results within a sub-page
/// (with search box on top) this page shows the title, a *back* button and
/// a search button that can be used to initiate a new search.
class FixedResultPage extends HookConsumerWidget {
  final Query query;

  const FixedResultPage({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(query.text),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              openSearchPage(context, ref, query);
            },
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, trace) {
        print(trace);
        return Center(child: Text('Error: $error'));
      },
    );
  }
}
