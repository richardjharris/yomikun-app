import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
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

    // This widget is the last resort if there were no exact sei/mei results,
    // so we need to handle the 'no matches at all' case.
    if (_cache.noResults) {
      return PlaceholderMessage(context.loc.noNameResultsFound, margin: 0);
    }

    final splitResult = query.splitResult;

    return Column(
      children: [
        if (splitResult != null) ...[
          NameGuessBox(
            sei ?? NameData.sei(splitResult.sei, '?'),
            mei ?? NameData.mei(splitResult.mei, '?'),
          ),
          const Divider(),
          Text(context.loc.allPossibleReadings),
        ],
        const SizedBox(height: 12),
        SeiMeiButtonSwitchBar(
          value: selectedNamePart.value,
          onChanged: (part) => selectedNamePart.value = part,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SlidableAutoCloseBehavior(
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
        ),
      ],
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: _NamePartBox(sei, label: context.loc.surname)),
            Flexible(child: _NamePartBox(mei, label: context.loc.givenName)),
          ],
        ),
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
        Text(name.kaki, style: Theme.of(context).textTheme.displaySmall),
        Text(name.formatYomi(formatPref),
            style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
