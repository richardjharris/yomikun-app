import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treemap/treemap.dart';
import 'package:yomikun/core/utilities/gender_color.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Displays a tree map showing the distribution of kanji for a given kana,
/// or kana for a given kanji.
class NameTreeMap extends ConsumerWidget {
  final CachedQueryResult results;
  final KakiYomi splitBy;

  const NameTreeMap({required this.results, required this.splitBy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (results.allZeroHits) {
      return Center(child: Text(context.loc.noNameResultsFound));
    }
    final treeResults = results.withAtLeastOneHit();
    final total = results.totalHits.toDouble();

    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    return AspectRatio(
      aspectRatio: 1.8,
      child: TreeMapLayout(
        tile: Binary(),
        children: [
          TreeNode.node(
            options: TreeNodeOptions(
              color: Colors.transparent,
              border: const Border(), //disable border
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: treeResults.map((r) {
              final color = genderColor(r.femaleRatio / 255.0);

              final label = r.format(splitBy, formatPref);

              // Log curve from 10 (min) to 70 (max)
              var fontSize = pow(r.hitsTotal / total, 0.6) * 120.0 + 5.0;

              if (label.length > 1) {
                fontSize = fontSize / (label.length * 0.5);
              }

              Widget textWidget = Text(
                label,
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center,
                locale: const Locale('ja'),
                overflow: TextOverflow.fade,
              );

              return TreeNode.leaf(
                value: r.hitsTotal,
                options: TreeNodeOptions(
                    child: Center(child: textWidget), color: color),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
