import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/share_service.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/core/widgets/name_page_action_buttons.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

final nameDataProvider =
    FutureProvider.family<NameData?, NameData>((ref, data) {
  final db = ref.watch(databaseProvider);
  return db.get(data.kaki, data.yomi, data.part);
});

/// Displays information and actions for a single [NameData] entry.
///
/// This is used when the user clicks on a search result or bookmarked name.
/// The information displayed is basically the same as in search results, but
/// there are more actions available, and actions are more discoverable.
class NamePage extends HookConsumerWidget {
  final NameData data;

  const NamePage({required this.data});

  static const routeName = '/name';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullData = ref.watch(nameDataProvider(data));

    final nameFormat =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text("${data.kaki} (${data.formatYomi(nameFormat)})"),
          const Spacer(),
          NamePartIcon(data.part),
        ]),
      ),
      body: fullData.when(
        data: (data) => data == null
            ? ErrorBox(context.loc.npNoResultFound)
            : NamePageInner(data: data),
        loading: () => const LoadingBox(),
        error: (error, stacktrace) => ErrorBox(error, stacktrace),
      ),
    );
  }
}

class NamePageInner extends HookConsumerWidget {
  final NameData data;

  const NamePageInner({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String nameUrl =
        Uri(path: NamePage.routeName, queryParameters: data.toRouteArgs())
            .toString();

    final isBookmarked =
        ref.watch(bookmarkDatabaseProvider).isBookmarked(nameUrl);

    final bottomButtonStyle =
        ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(0, 60)));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                NamePageActionButtons(
                  isBookmarked: isBookmarked,
                  onBookmark: () async {
                    bool added =
                        await ref.read(bookmarkDatabaseProvider).toggleBookmark(
                              nameUrl,
                              '${data.kaki} (${data.yomi})',
                            );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(added
                          ? context.loc.sbBookmarkAdded
                          : context.loc.sbBookmarkRemoved),
                    ));
                  },
                  onShare: () => ShareService.shareNameData(data),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(context.loc.npTotalHits),
                  const Spacer(),
                  Text(data.hitsTotal.toString()),
                ],
              ),
            ),
            GenderSplitGraph(data),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Text(context.loc.npFictionalHits),
                  const Spacer(),
                  Text(data.hitsPseudo.toString()),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: bottomButtonStyle,
                    onPressed: () {
                      Navigator.restorablePushNamed(context, '/result',
                          arguments: {
                            'text': data.kaki,
                            'mode': (data.part.toQueryMode() ?? QueryMode.mei)
                                .name
                                .toString(),
                          });
                    },
                    child: Text(context.loc.npSeeNamesWithSameKanji),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    style: bottomButtonStyle,
                    onPressed: () {
                      Navigator.restorablePushNamed(context, '/result',
                          arguments: {
                            'text': data.yomi,
                            'mode': (data.part.toQueryMode() ?? QueryMode.mei)
                                .name
                                .toString(),
                          });
                    },
                    child: Text(context.loc.npSeeNamesWithSameReading),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GenderSplitGraphItem {
  final String label;
  final Color color;
  final int count;

  const GenderSplitGraphItem({
    required this.label,
    required this.color,
    required this.count,
  });
}

class GenderSplitGraph extends StatelessWidget {
  final NameData data;

  const GenderSplitGraph(this.data);

  @override
  Widget build(BuildContext context) {
    List<GenderSplitGraphItem> items = [
      GenderSplitGraphItem(
        label: context.loc.npFemale,
        count: data.hitsFemale,
        color: Colors.pink,
      ),
      GenderSplitGraphItem(
        label: context.loc.npMale,
        count: data.hitsMale,
        color: Colors.blue,
      ),
      GenderSplitGraphItem(
        label: context.loc.npUnknown,
        count: data.hitsUnknown,
        color: Colors.grey,
      ),
    ].where((item) => item.count > 0).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Row(
              children: items
                  .map((item) => Expanded(
                        flex: item.count,
                        child: Container(
                          color: item.color,
                          height: 10,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        ...items
            .map((item) => Padding(
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  Text(item.label),
                  const Spacer(),
                  Text('${item.count}')
                ])))
            .toList(),
      ],
    );
  }
}
