import 'package:flutter/material.dart';
import 'package:yomikun/app/details/cached_query_result.dart';
import 'package:yomikun/app/details/name_pie_chart.dart';
import 'package:yomikun/core/localized_buildcontext.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/app/details/name_treemap.dart';
import 'package:yomikun/widgets/slidable_name_row.dart';

/// Show details for a particular name (kana/kanji) with visualisation.
class DetailsPage extends StatelessWidget {
  final QueryResult query;

  const DetailsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cache = CachedQueryResult(data: query.results);

    if (cache.noResults) {
      return Center(
          child: Text(context.loc.noResultsFound, textAlign: TextAlign.center));
    }

    return ListView(
      children: [
        if (cache.hasAtLeastOneHit) ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
            child: NameTreeMap(results: cache, ky: query.ky!),
          ),
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
