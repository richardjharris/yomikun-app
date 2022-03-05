import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/history/search_history/models/search_history_item.dart';
import 'package:yomikun/history/search_history/providers/search_history_providers.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/widgets/search_box.dart';

/// Shows recently visited names, grouped by date.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyListStream = ref.watch(searchHistoryListProvider);

    AlertDialog confirmDeleteDialog = AlertDialog(
      title: Text("Delete all history?"),
      content: Text("This cannot be undone."),
      actions: [
        TextButton(
            child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        TextButton(
            child: Text("Delete"),
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
              tooltip: context.loc.clearHistory,
              onPressed: () {
                showDialog(
                    context: context, builder: (_) => confirmDeleteDialog);
              },
            ),
          ),
        ],
      ),
      body: historyListStream.when(
        data: (data) => _historyList(context, ref, data),
        loading: () => const LoadingBox(),
        error: (e, stack) => ErrorBox(e, stack),
      ),
    );
  }

  Widget _historyList(
      BuildContext context, WidgetRef ref, List<SearchHistoryItem> items) {
    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noHistoryMessage);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return ListTile(
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: queryModeToColor(item.query.mode),
            ),
            child: Center(
                child: Text(queryModeToIcon(item.query.mode),
                    style: const TextStyle(fontSize: 20))),
          ),
          title: Text(
            item.query.text,
            style: const TextStyle(
              fontSize: 20,
              textBaseline: TextBaseline.ideographic,
            ),
          ),
        );
      },
    );
  }
}
