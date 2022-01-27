import 'package:flutter/material.dart';
import 'package:yomikun/app/details/name_pie_chart.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_mode.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/app/details/name_treemap.dart';
import 'package:yomikun/widgets/slidable_name_row.dart';

/// Show details for a particular name (kana/kanji) with visualisation.
class DetailsPage extends StatelessWidget {
  final QueryResult query;

  const DetailsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort results by hits descending
    var sortedResults = query.results.toList()
      ..sort((a, b) => b.hitsTotal.compareTo(a.hitsTotal));

    return ListView(
      children: [
        heading(context),
        const Divider(),
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: NameTreeMap(query: query),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: NamePieChart(query: query),
          margin: const EdgeInsets.all(10),
        ),
        // Make a ListTile for each item in sortedResults.
        for (var row in sortedResults)
          SlidableNameRow(
              data: row,
              key: ValueKey(row.key()),
              groupTag: sortedResults,
              showOnly: query.ky!.inverse()),
      ],
    );
  }

  Widget heading(BuildContext context) {
    final String part = query.mode == QueryMode.mei ? '名前' : '姓';
    final String ky = query.ky == KakiYomi.yomi ? '読み' : '漢字';
    return ListTile(
      title: Text("${query.text} ($part, $ky)",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center),
    );
  }
}
