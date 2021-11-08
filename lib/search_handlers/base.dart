import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/services/database.dart';

class NamePatterns {
  static var seiChars = r'\p{Script=Han}ケヶヵノツ';
  static var seiWithKana =
      r'(?:\p{Script=Han}+[ツノ]\p{Script=Han}+|茂り松|下り|走り|渡り|回り道|広エ|新タ|見ル野|反リ目|反り目|安カ川)';

  /// Pattern for a kanji surname, permitting kana in limited circumstances
  static RegExp seiPat =
      RegExp(r'^(?:[' + seiChars + r']+|' + seiWithKana + r')$', unicode: true);

  /// Pattern for a kanji given name
  static RegExp meiPat = RegExp(
      r'^[' + seiChars + r'\p{Script=Hiragana}\p{Script=Katakana}ー]+$',
      unicode: true);

  /// Pattern for a name reading
  static RegExp readingPat =
      RegExp(r'^[ー\p{Script=Hiragana}]+$', unicode: true);
}

abstract class SearchHandler {
  /// Returns true if this handler can handle the input query, based on the
  /// string alone.
  bool canHandle(String input);

  /// Returns true if this handler has at least one result, after performing
  /// a live lookup.
  Future<bool> hasResults(String input);

  static var all = [
    BrowseHandler(),
    SeiHandler(),
    MeiHandler(),
    KanaMeiHandler(),
    KanaSeiHandler(),
    FullNameHandler(),
  ];
}

/// Allows browsing through all names with wildcard queries. Performs a prefix
/// query if the query contains no wildcards. Accepts all input.
class BrowseHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return true;
  }

  @override
  Future<bool> hasResults(String input) {
    return Future.value(true);
  }
}

/// Interprets the query as a surname (written)
class SeiHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return NamePatterns.seiPat.hasMatch(input);
  }

  @override
  Future<bool> hasResults(String input) {
    return NameDatabase.hasPrefix(input, NamePart.sei, KakiYomi.kaki);
  }
}

/// Interprets the query as a surname (reading: in kana form)
class KanaSeiHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return NamePatterns.readingPat.hasMatch(input);
  }

  @override
  Future<bool> hasResults(String input) {
    return NameDatabase.hasPrefix(input, NamePart.sei, KakiYomi.yomi);
  }
}

/// Interprets the query as a first name (written)
class MeiHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return NamePatterns.meiPat.hasMatch(input);
  }

  @override
  Future<bool> hasResults(String input) {
    return NameDatabase.hasPrefix(input, NamePart.mei, KakiYomi.kaki);
  }
}

/// Interprets the query as a first name (reading: in kana form)
class KanaMeiHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return NamePatterns.seiPat.hasMatch(input);
  }

  @override
  Future<bool> hasResults(String input) {
    return NameDatabase.hasPrefix(input, NamePart.mei, KakiYomi.yomi);
  }
}

/// Interprets the query as a full name
class FullNameHandler implements SearchHandler {
  @override
  bool canHandle(String input) {
    return input.contains(' ') || NamePatterns.meiPat.hasMatch(input);
  }

  @override
  Future<bool> hasResults(String input) {
    /// TODO need to split name up and check.
    return Future.value(true);
  }
}
