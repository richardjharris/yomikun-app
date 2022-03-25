import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/models.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/share_service.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/navigation/open_search_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/widgets/search_results.dart';

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

    // TODO need to format yomi appropriately
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text("${data.kaki} (${data.yomi})"),
          const Spacer(),
          NamePartIcon(data.part),
        ]),
      ),
      body: fullData.when(
        data: (data) => data == null
            ? const ErrorBox('No results found')
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Text('${data.hitsTotal} hits'),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(data.toString()),
          ),
        ],
      ),
    );
  }
}
