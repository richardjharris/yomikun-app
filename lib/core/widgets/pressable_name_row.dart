import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/share_service.dart';
import 'package:yomikun/core/widgets/basic_name_row.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

/// Actions available.
enum Actions { bookmark, share }

/// Shows name data with actions on press (share, bookmark)
class PressableNameRow extends ConsumerWidget {
  final NameData data;
  final KakiYomi? showOnly;

  /// If set, shows each name's share relative to the total hit count.
  final int? totalHits;

  /// If true, show [NamePart] as an icon on the left of each row.
  final bool showNamePart;

  const PressableNameRow({
    required key,
    required this.data,
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

    return BasicNameRow(
      key: ValueKey(data.key()),
      nameData: data,
      showOnly: showOnly,
      totalHits: totalHits,
      showNamePart: showNamePart,
      onTap: () async {
        final selection = await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text('${data.kaki} (${data.yomi})'),
                children: [
                  SimpleDialogOption(
                    child: Text(isBookmarked
                        ? context.loc.removeBookmarkTooltip
                        : context.loc.addBookmarkTooltip),
                    onPressed: () {
                      Navigator.pop(context, Actions.bookmark);
                    },
                  ),
                  SimpleDialogOption(
                    child: Text(context.loc.shareAction),
                    onPressed: () {
                      Navigator.pop(context, Actions.share);
                    },
                  ),
                ],
              );
            });
        switch (selection) {
          case Actions.bookmark:
            String title = '${data.kaki} (${data.yomi})';
            bool added = await ref
                .read(bookmarkDatabaseProvider)
                .toggleBookmark(nameUrl, title);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(added
                  ? context.loc.sbBookmarkAdded
                  : context.loc.sbBookmarkRemoved),
            ));
            break;
          case Actions.share:
            await ShareService.shareNameData(data);
            break;
          case null:
            break;
        }
      },
    );
  }
}
