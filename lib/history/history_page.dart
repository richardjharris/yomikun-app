import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

final historyListProvider = StreamProvider((ref) => Stream.value([]));

/// Shows recently visited names, grouped by date.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyListStream = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.bookmarks),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: context.loc.clearHistory,
            onPressed: () {
              //ref.read(historyListProvider).value.clear();
            },
          ),
        ],
      ),
      body: historyListStream.when(
          data: (data) => _historyList(context, ref, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(
                child: Text('{$context.loc.error}: $e'),
              )),
    );
  }

  Widget _historyList(BuildContext context, WidgetRef ref, List<void> items) {
    if (items.isEmpty) {
      return PlaceholderMessage(context.loc.noHistoryMessage);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('$index'),
        );
      },
    );
  }
}
