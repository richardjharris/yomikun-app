import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treemap/treemap.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Displays a tree map showing the distribution of kanji for a given kana,
/// or kana for a given kanji.
class NameTreeMap extends ConsumerWidget {
  final CachedQueryResult results;
  final KakiYomi splitBy;

  const NameTreeMap({required this.results, required this.splitBy});

  static final maleColor = HSVColor.fromColor(Colors.blue.shade300);
  static final femaleColor = HSVColor.fromColor(Colors.pink.shade300);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (results.allZeroHits) {
      return const Center(child: Text('No results'));
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
              final color =
                  HSVColor.lerp(maleColor, femaleColor, r.genderMlScore / 255.0)
                      ?.toColor();

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
