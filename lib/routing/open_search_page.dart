import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/app/search/search_box.dart';
import 'package:yomikun/models/query.dart';

/// Pops all pages except for the SearchPage and feeds it the given query.
void openSearchPage(BuildContext context, WidgetRef ref, Query query) {
  ref.read(searchTextProvider).text = query.text;
  ref.read(queryModeProvider.notifier).state = query.mode;
  Navigator.of(context).popUntil((route) => route.isFirst);
}
