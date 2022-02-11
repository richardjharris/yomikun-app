import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: const Text('Bookmarks'),
      ),
      body: historyListStream.when(
          data: (data) => _historyList(ref, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(
                child: Text('Error: $e'),
              )),
    );
  }

  Widget _historyList(WidgetRef ref, List<void> items) {
    if (items.isEmpty) {
      return _noHistory();
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

  Widget _noHistory() {
    return Container(
      margin: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const Text('No history to display', textAlign: TextAlign.center),
    );
  }
}
