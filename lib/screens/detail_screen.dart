import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query.dart';

import 'package:collection/collection.dart';
import 'package:yomikun/util/locale.dart';

final List<Color> pieChartColors = [
  Colors.green,
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.cyan,
  Colors.brown,
  Colors.grey,
  Colors.lime,
  Colors.pink,
  Colors.teal,
  Colors.indigo,
  Colors.lightGreen,
  Colors.limeAccent,
  Colors.indigoAccent,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.pinkAccent,
  Colors.greenAccent,
  Colors.blueAccent,
];

/// Screen for showing details about a particular name.
class DetailScreen extends StatelessWidget {
  final Query query;

  const DetailScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sortedResults = query.results.toList()
      ..sort((a, b) => b.hitsTotal.compareTo(a.hitsTotal));

    return ListView(
      children: [
        heading(context),
        const Divider(),
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: pieChart(),
          margin: const EdgeInsets.only(top: 14),
        ),
        // Make a ListTile for each item in sortedResults.
        for (var row in sortedResults)
          ListTile(
            title: Text(query.ky == KakiYomi.yomi ? row.kaki : row.yomi,
                locale: japaneseLocale),
            subtitle: Text("${addThousands(row.hitsTotal)} hits"),
          ),
      ],
    );
  }

  /// Add thousand separators to a number.
  /// For example, 123456789 becomes 1,234,567,890.
  String addThousands(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match.group(1)},');
  }

  Widget heading(BuildContext context) {
    final String part = query.part! == NamePart.mei ? '名前' : '姓';
    final String ky = query.ky! == KakiYomi.yomi ? '読み' : '漢字';
    return ListTile(
      title: Text("${query.query} ($part, $ky)",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center),
    );
  }

  Widget pieChart() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: PieChart(
        PieChartData(
          sections: pieChartSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> pieChartSections() {
    var results =
        query.results.where((r) => r.hitsTotal > 0).mapIndexed((i, row) {
      var label = query.ky == KakiYomi.yomi ? row.kaki : row.yomi;

      return PieChartSectionData(
        color: pieChartColors[i % pieChartColors.length],
        value: row.hitsTotal.toDouble(),
        title: "$label (${addThousands(row.hitsTotal)})",
        radius: 100,
      );
    }).toList();

    if (results.isEmpty) {
      results = [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: "No results",
          radius: 100,
        ),
      ];
    }

    return results;
  }
}
