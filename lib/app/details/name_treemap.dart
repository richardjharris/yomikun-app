import 'package:flutter/material.dart';
import 'package:treemap/treemap.dart';
import 'package:yomikun/app/details/cached_query_result.dart';

import 'package:yomikun/core/locale.dart';
import 'package:yomikun/models/namedata.dart';

/// Displays a tree map showing the distribution of kanji for a given kana,
/// or kana for a given kanji.
class NameTreeMap extends StatelessWidget {
  final CachedQueryResult results;
  final KakiYomi ky;

  const NameTreeMap({required this.results, required this.ky});

  static final maleColor = HSVColor.fromColor(Colors.blue.shade300);
  static final femaleColor = HSVColor.fromColor(Colors.pink.shade300);

  @override
  Widget build(BuildContext context) {
    if (results.allZeroHits) {
      return const Center(child: Text('No results'));
    }
    final treeResults = results.withAtLeastOneHit();
    final total = results.totalHits.toDouble();

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

              final label = ky == KakiYomi.kaki ? r.yomi : r.kaki;
              final fontSize = (r.hitsTotal / total) * 64 + 10;
              Widget textWidget = Text(
                label,
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center,
                locale: japaneseLocale,
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
