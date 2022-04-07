import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/utilities/number_format.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Displays a pie chart (actually a donut) showing the distribution of
/// kanji for a given kana, or kana for a given kanji.
class NamePieChart extends ConsumerWidget {
  final CachedQueryResult results;
  final KakiYomi splitBy;
  final Function(NameData)? onClick;

  const NamePieChart({
    required this.results,
    required this.splitBy,
    this.onClick,
  });

  static final List<Color> pieChartColorsLightMode = [
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

  static final List<Color> pieChartColorsDarkMode =
      pieChartColorsLightMode.map((c) {
    return c.withOpacity(0.75);
  }).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    final data = pieChartData();
    final sections = pieChartSections(data, context, formatPref);

    return AspectRatio(
      aspectRatio: 1.0,
      child: PieChart(
        PieChartData(
          sections: sections,
          pieTouchData: onClick == null || data.isEmpty
              ? null
              : PieTouchData(touchCallback: (flEvent, pieTouchResponse) {
                  if (flEvent is! FlTapUpEvent) return;
                  final sectionIndex =
                      pieTouchResponse?.touchedSection?.touchedSectionIndex;
                  if (sectionIndex == null) return;

                  try {
                    onClick?.call(data[sectionIndex]);
                  } catch (e) {
                    debugPrint('Error in pie chart onClick: $e');
                  }
                }),
        ),
      ),
    );
  }

  List<NameData> pieChartData() {
    List<NameData> pieResults = results.withAtLeastOneHit().toList();
    // Sort results by name. Sorting by hits desc leads to the small items being
    // bunched together, and their labels cannot be read.
    pieResults.sortBy<String>((e) => e.key());
    return pieResults;
  }

  List<PieChartSectionData> pieChartSections(
    List<NameData> data,
    BuildContext context,
    NameFormatPreference formatPref,
  ) {
    var colors = pieChartColorsLightMode;
    if (Theme.of(context).brightness == Brightness.dark) {
      colors = pieChartColorsDarkMode;
    }

    // For busy pie charts, hide labels for segments representing <1% of the
    // total.
    final int total = results.totalHits;
    double threshold;
    double buffer = 0;
    if (data.length < 5) {
      threshold = 0;
      // Pad out smaller answers so they're easier to see, even if it's not
      // strictly proportional.
      buffer = total * 0.02;
    } else {
      threshold = total * 0.01;
    }

    var sections = data.mapIndexed((i, row) {
      var label = row.format(splitBy, formatPref);
      //var sizeMult = (row.hitsTotal.toDouble() / total).clamp(0.1, 1.0);

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: row.hitsTotal.toDouble() + buffer,
        title: '',
        radius: 100,
        badgeWidget: row.hitsTotal >= threshold
            ? Text("$label (${addThousands(row.hitsTotal)})",
                locale: const Locale('ja'))
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
