/// Utilities to split Japanese names into two parts when the space is missing.
///
/// Japanese names are usually written without spaces, e.g. 山田太郎 is
/// implicitly understood to be 山田(surname) + 太郎(given name). Names that can
/// be both surnames and given names are fairly rare, so it is usually obvious
/// which one is which.
///
/// We do not currently use frequency information in the event of a tie (i.e.
/// not sure which way name is ordered). Could improve on this.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/search/models.dart';

part 'split.freezed.dart';

/// Holds the result of a split operation: the surname (sei) and given name
/// (mei) components.
@freezed
class SplitResult with _$SplitResult {
  factory SplitResult({required String sei, required String mei}) =
      _SplitResult;
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
