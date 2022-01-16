import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_result.dart';

import 'package:collection/collection.dart';
import 'package:yomikun/core/dakuten.dart';
import 'package:yomikun/core/locale.dart';

final List<Color> pieChartColorsLightMode = [
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

final List<Color> pieChartColorsDarkMode = pieChartColorsLightMode.map((c) {
  return c.withOpacity(0.75);
}).toList();

/// Screen for showing details about a particular name.
class DetailScreen extends StatelessWidget {
  final QueryResult query;

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
          child: pieChart(context),
          margin: const EdgeInsets.only(top: 14),
        ),
        // Make a ListTile for each item in sortedResults.
        for (var row in sortedResults)
          ListTile(
            title: Text(
                query.ky == KakiYomi.yomi ? row.kaki : expandDakuten(row.yomi),
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
    final String part = query.mode == QueryMode.mei ? '名前' : '姓';
    final String ky = query.ky == KakiYomi.yomi ? '読み' : '漢字';
    return ListTile(
      title: Text("${query.text} ($part, $ky)",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center),
    );
  }

  Widget pieChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: PieChart(
        PieChartData(
          sections: pieChartSections(context),
        ),
      ),
    );
  }

  List<PieChartSectionData> pieChartSections(BuildContext context) {
    // Sort results by hits desc
    var results = query.results.where((r) => r.hitsTotal > 0).toList();

    var colors = pieChartColorsLightMode;
    if (Theme.of(context).brightness == Brightness.dark) {
      colors = pieChartColorsDarkMode;
    }

    // For busy pie charts, hide labels for segments representing <1% of the
    // total.
    final int total = results.map((e) => e.hitsTotal).sum;
    double threshold;
    double buffer = 0;
    if (results.length < 5) {
      threshold = 0;
      // Pad out smaller answers so they're easier to see, even if it's not
      // strictly proportional.
      buffer = total * 0.02;
    } else {
      threshold = total * 0.01;
    }

    var sections =
        query.results.where((r) => r.hitsTotal > 0).mapIndexed((i, row) {
      var label = query.ky == KakiYomi.yomi ? row.kaki : row.yomi;

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: row.hitsTotal.toDouble() + buffer,
        title: '',
        radius: 100,
        badgeWidget: row.hitsTotal >= threshold
            ? Text("${expandDakuten(label)} (${addThousands(row.hitsTotal)})",
                locale: japaneseLocale)
            : null,
      );
    }).toList();

    if (sections.isEmpty) {
      sections = [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: "No results",
          radius: 100,
        ),
      ];
    }

    return sections;
  }
}
