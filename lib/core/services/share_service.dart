import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yomikun/search/models.dart';

class ShareService {
  /// Share NameData to the user's selected app.
  ///
  /// On iPad, [sharePositionOrigin] is required. This can be computed with the
  /// helper method [getSharePositionOrigin(context)].
  static Future<void> shareNameData(NameData data,
      {Rect? sharePositionOrigin}) {
    final front = data.kaki;
    final back = data.yomi;
    return SharePlus.instance.share(
      ShareParams(
        text: back,
        subject: front,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}

Rect getSharePositionOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  return box!.localToGlobal(Offset.zero) & box.size;
}
