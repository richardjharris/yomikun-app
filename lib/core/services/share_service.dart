import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yomikun/search/models.dart';

class ShareService {
  final BuildContext context;

  ShareService(this.context);

  Rect get sharePositionOrigin {
    final box = context.findRenderObject() as RenderBox?;
    return box!.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> shareCard(String front, String back) {
    debugPrint("ShareService: sharing $front ($back)");
    return SharePlus.instance.share(ShareParams(
      text: back,
      subject: front,
      sharePositionOrigin: sharePositionOrigin,
    ));
  }

  /// Share NameData to the user's selected app.
  ///
  /// On iPad, [sharePositionOrigin] is required. This can be computed with the
  /// helper method [getSharePositionOrigin(context)].
  Future<void> shareNameData(NameData data) {
    return shareCard(data.kaki, data.yomi);
  }
}
