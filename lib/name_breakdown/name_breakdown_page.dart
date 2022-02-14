import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/core/widgets/slidable_name_row.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/cached_query_result.dart';
import 'package:yomikun/name_breakdown/widgets/name_pie_chart.dart';
import 'package:yomikun/name_breakdown/widgets/name_treemap.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

enum GenderFilter { male, female, all }

/// For a given name, show a breakdown of readings (if kanji) or kanji forms
/// (if kana) sorted by most popular.
// TODO coupled too strongly to the SearchResults? bookmarkBuilder or similar?
// TODO update 'no bookmarks' text.
class NameBreakdownPage extends HookConsumerWidget {
  final QueryResult query;

  const NameBreakdownPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viz = ref.watch(settingsControllerProvider).nameVisualization;
    // TODO this is not cached across builds.
    final cache = CachedQueryResult(data: query.results);
    final inverseKy = query.ky!.inverse();

    final genderFilter = useState(GenderFilter.all);
    cache.setGenderFilter(genderFilter.value);

    if (cache.noResults) {
      return PlaceholderMessage(context.loc.noNameResultsFound, margin: 0);
    }

    final String pageBookmarkUri = Uri(path: '/result', queryParameters: {
      'text': query.text,
      'mode': query.mode.name,
    }).toString();

    final String pageBookmarkTitle = query.text;

    final isBookmarked =
        ref.watch(bookmarkDatabaseProvider).isBookmarked(pageBookmarkUri);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            children: [
              ButtonSwitchBar(
                items: const [
                  MapEntry(GenderFilter.female, 'Female'),
                  MapEntry(GenderFilter.male, 'Male'),
                  MapEntry(GenderFilter.all, 'All'),
                ],
                onChanged: (GenderFilter value) {
                  genderFilter.value = value;
                },
                value: genderFilter.value,
              ),
              const Spacer(),
              _ActionButtons(
                isBookmarked: isBookmarked,
                onBookmark: () {
                  ref.read(bookmarkDatabaseProvider).toggleBookmark(
                        pageBookmarkUri,
                        pageBookmarkTitle,
                      );
                },
                onShare: () {
                  // TODO - have to share some breakdown of the top
                  // readings.
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (cache.hasAtLeastOneHit &&
                  viz == NameVisualizationPreference.treeMap) ...[
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 400),
                  child: NameTreeMap(results: cache, splitBy: inverseKy),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
              ],
              if (cache.hasAtLeastOneHit &&
                  viz == NameVisualizationPreference.pieChart) ...[
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 400),
                  child: NamePieChart(results: cache, splitBy: inverseKy),
                  margin: const EdgeInsets.all(10),
                ),
              ],
              // Make a ListTile for each item in sortedResults.
              for (var row in cache.sortedByHitsDescending())
                SlidableNameRow(
                    data: row,
                    key: ValueKey(row.key()),
                    groupTag: cache,
                    showOnly: inverseKy),
            ],
          ),
        ),
      ],
    );
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
          tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: onShare,
          tooltip: 'Share',
        ),
      ],
    );
  }
}
