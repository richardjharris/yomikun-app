import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/screens/search/search_results.dart';

class ResultScreen extends HookConsumerWidget {
  final Query query;

  const ResultScreen({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(query.text),
      ),
      body: _body(ref),
    );
  }

  Widget _body(WidgetRef ref) {
    final result = ref.watch(queryResultProvider(query));
    return result.when(
      data: (data) => SearchResults(result: data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, trace) => Center(child: Text('Error: $error')),
    );
  }
}
