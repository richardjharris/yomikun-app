import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/query_list_tile.dart';
import 'package:yomikun/history/search_history/models/history_grouping.dart';
import 'package:yomikun/history/search_history/models/search_history_item.dart';
import 'package:yomikun/history/search_history/providers/search_history_providers.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

/// Shows recently visited names, grouped by date.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyListStream = ref.watch(searchHistoryListProvider);

    AlertDialog confirmDeleteDialog = AlertDialog(
      title: Text(context.loc.clearAllHistoryConfirm),
      content: Text(context.loc.thisCannotBeUndone),
      actions: [
        TextButton(
            child: Text(context.loc.cancelAction),
            onPressed: () => Navigator.pop(context)),
        TextButton(
            child: Text(context.loc.clearAllHistoryConfirmAction),
            onPressed: () {
              ref.read(searchHistoryServiceProvider).clearHistory();
              Navigator.pop(context);
            }),
      ],
    );

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(context.loc.history),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              tooltip: context.loc.clearAllHistory,
              onPressed: () {
                showDialog(
                    context: context, builder: (_) => confirmDeleteDialog);
              },
            ),
          ),
        ],
      ),
      body: historyListStream.when(
        data: (items) => HistoryList(items: items),
        loading: () => const LoadingBox(),
        error: (e, stack) => ErrorBox(e, stack),
      ),
    );
  }
}

class HistoryList extends StatelessWidget {
  final List<SearchHistoryItem> items;

  const HistoryList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noHistoryMessage);
    }

    // Identify grouping points in the history
    var groups = GroupedHistoryList.fromItems(items);

    return Padding(
      padding: const EdgeInsets.only(top: 0), // 10 if grouping
      child: ListView.builder(
        itemCount: groups.listItemCount,
        itemBuilder: (BuildContext context, int index) {
          final item = groups.listItemAt(index);
          if (item is HistoryListGroup) {
            return HistoryListHeader(item: item);
          } else if (item is SearchHistoryItem) {
            return QueryListTile(query: item.query);
          } else {
            throw Exception("Unknown history group item type");
          }
        },
      ),
    );
  }
}

class HistoryListHeader extends StatelessWidget {
  final HistoryListGroup item;

  const HistoryListHeader({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime start = item.start.toLocal();
    DateTime end = item.end.toLocal();

    // e.g. 'Feb 21, 2022 22:38 - Feb 22, 2022 00:37' if diff day,
    // otherwise 'Feb 21, 2022 22:07 - 22:38'
    // Locale-specific.
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    DateFormat startFormat = DateFormat.yMMMd(tag).add_Hm();
    DateFormat endFormat = start.day == end.day
        ? DateFormat.Hm(tag)
        : DateFormat.yMMMd(tag).add_Hm();

    var divider = (tag ?? '').startsWith('ja') ? '−' : '-';

    String headingText =
        '${startFormat.format(start)} $divider ${endFormat.format(end)}';

    // Create a heading with the date range
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      color: Theme.of(context).colorScheme.background,
      child: Text(
        headingText,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
