// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/search/models.dart';

/// Holds the result of a split operation: the surname (sei) and given name
/// (mei) components.
class SplitResult {
  final String sei;
  final String mei;

  SplitResult({required this.sei, required this.mei});

  @override
  String toString() => 'SplitResult(sei: $sei, mei: $mei)';
}

RegExp whitespaceRe = RegExp(r'\s+', unicode: true);

/// Try to split a kanji name into surname and forename parts.
Future<SplitResult?> splitKanjiName(NameDatabase db, String name,
    {bool tryReverse = true}) async {
  KakiYomi ky = KakiYomi.kaki;

  name = name.trim();

  // If there is a space, we're done.
  var parts = name.split(whitespaceRe);
  if (parts.length > 1) {
    if (parts.length != 2) {
      // Ignore the middle parts
      parts = [parts[0], parts[parts.length - 1]];
    }
    return SplitResult(sei: parts[0], mei: parts[1]);
  }

  // Try to match the largest possible surname
  for (int i = name.length - 1; i >= 1; i--) {
    final sei = name.substring(0, i);
    final mei = name.substring(i);
    if (await db.hasExact(sei, NamePart.sei, ky)) {
      return SplitResult(sei: sei, mei: mei);
    }
  }

  // Try to match the largest possible first name
  for (int i = 1; i <= name.length - 1; i++) {
    final sei = name.substring(0, i);
    final mei = name.substring(i);
    if (await db.hasExact(mei, NamePart.mei, ky)) {
      return SplitResult(sei: sei, mei: mei);
    }
  }

  // Give up.
  return null;
}
