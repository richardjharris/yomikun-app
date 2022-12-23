import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/share_service.dart';
import 'package:yomikun/core/widgets/basic_name_row.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

/// Shows name data with slidable actions (share, bookmark)
class SlidableNameRow extends ConsumerWidget {
  final NameData data;
  final Object groupTag;
  final KakiYomi? showOnly;

  /// If set, shows each name's share relative to the total hit count.
  final int? totalHits;

  /// If true, show [NamePart] as an icon on the left of each row.
  final bool showNamePart;

  const SlidableNameRow({
    required key,
    required this.data,
    required this.groupTag,
    this.showOnly,
    this.totalHits,
    this.showNamePart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String nameUrl =
        Uri(path: '/name', queryParameters: data.toRouteArgs()).toString();

    final isBookmarked =
        ref.watch(bookmarkDatabaseProvider).isBookmarked(nameUrl);

    return Slidable(
      key: ValueKey(data.key()),
      groupTag: groupTag,
      endActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green.shade900,
            foregroundColor: Colors.white,
            onPressed: (context) async {
              String title = '${data.kaki} (${data.yomi})';
              bool added = await ref
                  .read(bookmarkDatabaseProvider)
                  .toggleBookmark(nameUrl, title);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(added
                    ? context.loc.sbBookmarkAdded
                    : context.loc.sbBookmarkRemoved),
              ));
            },
            icon: isBookmarked ? Icons.star : Icons.star_border,
            label: isBookmarked
                ? context.loc.removeBookmarkAction
                : context.loc.addBookmarkAction,
          ),
          SlidableAction(
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            onPressed: (context) {
              ShareService.shareNameData(data);
            },
            icon: Icons.share,
            label: context.loc.shareAction,
          ),
        ],
      ),
      child: BasicNameRow(
        key: ValueKey(data.key()),
        nameData: data,
        showOnly: showOnly,
        totalHits: totalHits,
        showNamePart: showNamePart,
        onTap: () {
          Navigator.pushNamed(context, '/name', arguments: data.toRouteArgs());
        },
      ),
    );
  }
}
