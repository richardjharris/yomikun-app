import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Page to show results of a Person name lookup i.e. two parts
class NamePersonPage extends HookWidget {
  final QueryResult query;
  final CachedQueryResult _cache;

  NamePersonPage({Key? key, required this.query})
      : _cache = CachedQueryResult(data: query.results),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    NameData? sei = _cache.getMostPopular(NamePart.sei);
    NameData? mei = _cache.getMostPopular(NamePart.mei);

    final selectedNamePart = useState(NamePart.sei);

    return Column(
      children: [
        if (mei != null && sei != null) ...[
          NameGuessBox(sei, mei),
          const Divider(),
          const Text('All possible readings:'),
        ],
        const SizedBox(height: 12),
        NamePartSwitchButtons(
          value: selectedNamePart.value,
          onChanged: (part) => selectedNamePart.value = part,
        ),
        Expanded(
          child: ListView(
            children: _cache
                .sortedByHitsDescending()
                .where((name) => name.part == selectedNamePart.value)
                .map<Widget>((name) => SlidableNameRow(
                      data: name,
                      key: ValueKey(name.key()),
                      groupTag: _cache,
                      showOnly: KakiYomi.yomi,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// Button to switch between name part
class NamePartSwitchButtons extends ConsumerWidget {
  final NamePart value;
  final ValueChanged<NamePart> onChanged;

  const NamePartSwitchButtons(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = [value == NamePart.sei, value == NamePart.mei];
    return ToggleButtons(
      children: const [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Surname')),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Given name')),
      ],
      onPressed: (int index) {
        onChanged(index == 0 ? NamePart.sei : NamePart.mei);
      },
      isSelected: isSelected,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }
}

/// Shows a box with the best guess of the reading of a name.
class NameGuessBox extends StatelessWidget {
  final NameData sei;
  final NameData mei;

  const NameGuessBox(this.sei, this.mei);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: _NamePartBox(sei, label: 'Surname')),
          Flexible(child: _NamePartBox(mei, label: 'Given name')),
        ],
      ),
    );
  }
}

class _NamePartBox extends ConsumerWidget {
  final NameData name;
  final String? label;

  const _NamePartBox(this.name, {this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    return Column(
      children: [
        if (label != null)
          Text(label!, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(name.kaki, style: Theme.of(context).textTheme.headline3),
        Text(name.formatYomi(formatPref),
            style: Theme.of(context).textTheme.headline6),
      ],
    );
  }
}
