import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yomikun/core/widgets/basic_name_row.dart';
import 'package:yomikun/search/models.dart';

/// Shows name data with slidable actions (share, bookmark)
class SlidableNameRow extends StatelessWidget {
  final NameData data;
  final Object groupTag;
  final KakiYomi? showOnly;

  const SlidableNameRow({
    required key,
    required this.data,
    required this.groupTag,
    this.showOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(data.key()),
      child: BasicNameRow(
          key: ValueKey(data.key()), nameData: data, showOnly: showOnly),
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green.shade900,
            foregroundColor: Colors.white,
            onPressed: (context) {
              // ...
            },
            icon: Icons.favorite,
            label: 'Bookmark',
          ),
          SlidableAction(
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            onPressed: (context) {
              final front = data.kaki;
              final back = data.yomi;
              Share.share(back, subject: front);
            },
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
    );
  }
}
