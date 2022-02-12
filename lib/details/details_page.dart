import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/details/cached_query_result.dart';
import 'package:yomikun/details/widgets/name_pie_chart.dart';
import 'package:yomikun/details/widgets/name_treemap.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Show details for a particular name (kana/kanji) with visualisation.
class DetailsPage extends ConsumerWidget {
  final QueryResult query;

  const DetailsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viz = ref.watch(settingsControllerProvider).nameVisualization;
    final cache = CachedQueryResult(data: query.results);

    if (cache.noResults) {
      return PlaceholderMessage(context.loc.noNameResultsFound, margin: 0);
    }

    return ListView(
      children: [
        if (cache.hasAtLeastOneHit &&
            viz == NameVisualizationPreference.treeMap) ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: NameTreeMap(results: cache, ky: query.ky!),
          ),
        ],
        if (cache.hasAtLeastOneHit &&
            viz == NameVisualizationPreference.pieChart) ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: NamePieChart(results: cache, ky: query.ky!),
            margin: const EdgeInsets.all(10),
          ),
        ],
        // Make a ListTile for each item in sortedResults.
        for (var row in cache.sortedByHitsDescending())
          SlidableNameRow(
              data: row,
              key: ValueKey(row.key()),
              groupTag: cache,
              showOnly: query.ky!.inverse()),
      ],
    );
  }
}
