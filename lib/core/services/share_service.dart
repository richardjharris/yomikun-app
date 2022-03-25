import 'package:share_plus/share_plus.dart';
import 'package:yomikun/search/models.dart';

class ShareService {
  /// Share NameData to the user's selected app.
  static Future<void> shareNameData(NameData data) {
    final front = data.kaki;
    final back = data.yomi;
    return Share.share(back, subject: front);
  }
}
