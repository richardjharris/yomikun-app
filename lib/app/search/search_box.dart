import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/providers/search_providers.dart';
import 'package:yomikun/models/query_mode.dart';

/// Allows the user to change the search query and mode.
class SearchBox extends ConsumerWidget {
  final VoidCallback? onClose;
  final VoidCallback? onUpdate;

  const SearchBox({this.onUpdate, this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = ref.watch(searchTextProvider.notifier);
    return Row(children: [
      Expanded(
          child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).primaryColorLight,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              ref.read(searchTextProvider).clear();
              if (onClose != null) onClose!();
            },
          ),
        ),
      )),
      const SizedBox(width: 10),
      QueryModeButton(),
    ]);
  }
}

class QueryModeButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryMode = ref.watch(queryModeProvider);

    // If query mode is mei/sei, indicates if the alternate mode also has results.
    // TODO preserve previous value if loading.
    final bool queryModeAltAvailable =
        ref.watch(queryModeAltAvailableProvider).asData?.value ?? false;

    return IconButton(
      icon: Text(_queryModeToIcon(queryMode),
          style: queryModeAltAvailable
              ? const TextStyle(color: Colors.yellow)
              : null),
      onPressed: () => advanceMode(ref),
      iconSize: 30,
      tooltip: 'Change query mode',
    );
  }

  /// Advances the query mode to the next available mode.
  void advanceMode(WidgetRef ref) async {
    final allowedModes = await ref.read(allowedQueryModesProvider.future);
    final currentMode = ref.read(queryModeProvider);

    int index = allowedModes.indexOf(currentMode);
    int newIndex = (index + 1) % allowedModes.length;
    ref.read(queryModeProvider.notifier).state = allowedModes[newIndex];
  }

  String _queryModeToIcon(QueryMode mode) {
    switch (mode) {
      case QueryMode.mei:
        return '名';
      case QueryMode.sei:
        return '姓';
      case QueryMode.wildcard:
        return '✴';
      case QueryMode.person:
        return '人';
    }
  }
}
