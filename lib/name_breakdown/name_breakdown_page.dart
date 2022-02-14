import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/name_breakdown/widgets/name_pie_chart.dart';
import 'package:yomikun/name_breakdown/widgets/name_treemap.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

enum GenderFilter { male, female, all }

/// For a given name, show a breakdown of readings (if kanji) or kanji forms
/// (if kana) sorted by most popular.
class NameBreakdownPage extends HookConsumerWidget {
  final QueryResult query;

  const NameBreakdownPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viz = ref.watch(settingsControllerProvider).nameVisualization;
    // TODO this is not cached across builds.
    final cache = CachedQueryResult(data: query.results);
    final inverseKy = query.ky!.inverse();

    final genderFilter = useState(GenderFilter.all);
    cache.setGenderFilter(genderFilter.value);

    if (cache.noResults) {
      return PlaceholderMessage(context.loc.noNameResultsFound, margin: 0);
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        ButtonSwitchBar(
          items: const [
            MapEntry(GenderFilter.female, 'Female'),
            MapEntry(GenderFilter.male, 'Male'),
            MapEntry(GenderFilter.all, 'All'),
          ],
          onChanged: (GenderFilter value) {
            genderFilter.value = value;
          },
          value: genderFilter.value,
        ),
        Expanded(
          child: ListView(
            children: [
              if (cache.hasAtLeastOneHit &&
                  viz == NameVisualizationPreference.treeMap) ...[
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 400),
                  child: NameTreeMap(results: cache, splitBy: inverseKy),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
              ],
              if (cache.hasAtLeastOneHit &&
                  viz == NameVisualizationPreference.pieChart) ...[
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 400),
                  child: NamePieChart(results: cache, splitBy: inverseKy),
                  margin: const EdgeInsets.all(10),
                ),
              ],
              // Make a ListTile for each item in sortedResults.
              for (var row in cache.sortedByHitsDescending())
                SlidableNameRow(
                    data: row,
                    key: ValueKey(row.key()),
                    groupTag: cache,
                    showOnly: inverseKy),
            ],
          ),
        ),
      ],
    );
  }
}
