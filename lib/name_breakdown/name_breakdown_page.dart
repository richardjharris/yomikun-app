import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yomikun/core/models.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/core/widgets/pressable_name_row.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/fixed_result/fixed_result_page.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/name_breakdown/widgets/name_pie_chart.dart';
import 'package:yomikun/name_breakdown/widgets/name_treemap.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// For a given name, show a breakdown of readings (if kanji) or kanji forms
/// (if kana) sorted by most popular.
class NameBreakdownPage extends HookConsumerWidget {
  final QueryResult query;

  const NameBreakdownPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viz = ref.watch(settingsControllerProvider).nameVisualization;
    final cache = CachedQueryResult(data: query.results);
    final inverseKy = query.ky!.inverse();

    final genderFilter = useState(GenderFilter.all);
    cache.setGenderFilter(genderFilter.value);

    if (cache.noResults) {
      return PlaceholderMessage(context.loc.noNameResultsFound, margin: 0);
    }

    final String pageBookmarkUri = Uri(
      path: FixedResultPage.routeName,
      queryParameters: {
        'text': query.text,
        'mode': query.mode.name,
      },
    ).toString();

    final String pageBookmarkTitle = query.text;

    final isBookmarked =
        ref.watch(bookmarkDatabaseProvider).isBookmarked(pageBookmarkUri);

    List<NameData> items = cache.sortedByHitsDescending().toList();

    List<Widget> charts = [
      if (cache.hasAtLeastOneHit &&
          viz == NameVisualizationPreference.treeMap) ...[
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: NameTreeMap(results: cache, splitBy: inverseKy),
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
      ],
      if (cache.hasAtLeastOneHit &&
          viz == NameVisualizationPreference.pieChart) ...[
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: NamePieChart(results: cache, splitBy: inverseKy),
          margin: const EdgeInsets.all(10),
        ),
      ],
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            children: [
              if (query.mode == QueryMode.mei)
                GenderFilterButtonSwitchBar.forValue(genderFilter),
              const Spacer(),
              _ActionButtons(
                isBookmarked: isBookmarked,
                onBookmark: () async {
                  bool added =
                      await ref.read(bookmarkDatabaseProvider).toggleBookmark(
                            pageBookmarkUri,
                            pageBookmarkTitle,
                          );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(added
                        ? context.loc.sbBookmarkAdded
                        : context.loc.sbBookmarkRemoved),
                  ));
                },
                onShare: () => onShareWholePage(cache, ref),
              ),
            ],
          ),
        ),
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: items.length + charts.length,
              itemBuilder: (context, index) {
                if (index < charts.length) {
                  return charts[index];
                } else {
                  final item = items[index - charts.length];
                  return SlidableNameRow(
                    data: item,
                    key: ValueKey(item.key()),
                    groupTag: cache,
                    showOnly: inverseKy,
                    totalHits: cache.totalHits,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Invoked when clicking the page-global 'share' button. This will share
  /// the top five readings for a name.
  void onShareWholePage(CachedQueryResult cache, WidgetRef ref) {
    final NameFormatPreference nameFormat =
        ref.read(settingsControllerProvider).nameFormat;

    final String front = '${query.text} (${queryModeToIcon(query.mode)})';

    final String back = cache.sortedByHitsDescending().take(5).map((row) {
      String label = query.ky == KakiYomi.kaki ? row.yomi : row.kaki;
      label = formatYomiString(label, nameFormat);
      String percent =
          (row.hitsTotal / cache.totalHits * 100).toStringAsFixed(1);
      return '$label ($percent%)';
    }).join('; ');

    Share.share(back, subject: front);
    debugPrint("Shared $front ($back)");
  }
}

class _ActionButtons extends ConsumerWidget {
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const _ActionButtons(
      {Key? key,
      required this.isBookmarked,
      required this.onBookmark,
      required this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(isBookmarked ? Icons.star : Icons.star_border),
          onPressed: onBookmark,
          tooltip: isBookmarked
              ? context.loc.removeBookmarkTooltip
              : context.loc.addBookmarkTooltip,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: onShare,
          tooltip: context.loc.shareTooltip,
        ),
      ],
    );
  }
}
