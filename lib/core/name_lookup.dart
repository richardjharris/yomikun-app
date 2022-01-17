import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/services/name_repository.dart';

/// Utilities for parsing and querying names.

/// Interpret query as kaki/yomi based on its contents.
KakiYomi guessKY(String text) {
  return text.contains(RegExp(r'\p{Script=Han}', unicode: true))
      ? KakiYomi.kaki
      : KakiYomi.yomi;
}

/// Given a query, return a list of QueryModes that are possible for the query.
/// This is used e.g. by the search box mode selector to allow the user to
/// toggle between available query modes.
Future<List<QueryMode>> getAllowedQueryModes(
    NameRepository db, String text) async {
  text = _cleanInputText(text);

  if (text.contains(RegExp(r'[\*\?＊？]', unicode: true))) {
    // Text contains wildcard markers, so must use wildcard mode
    return [QueryMode.wildcard];
  } else if (text.contains(' ') || text.contains('　')) {
    // Text contains whitespace, so must be a person
    return [QueryMode.person];
  }

  KakiYomi ky = guessKY(text);

  final meiMatch = await db.hasPrefix(text, NamePart.mei, ky);
  final seiMatch = await db.hasPrefix(text, NamePart.sei, ky);

  if (meiMatch || seiMatch) {
    return [
      if (meiMatch) QueryMode.mei,
      if (seiMatch) QueryMode.sei,
    ];
  } else {
    // Input does not match mei/sei but might be a full name without any spaces
    // in between. (Need to test this!)
    /// TODO need to remember last user-selected mode and preserve that if possible
    return [QueryMode.mei, QueryMode.sei, QueryMode.person];
  }
}

/// Interpret the provided query string and mode, and return a QueryResult.
/// Providers results that update when the query text/mode changes.
Future<QueryResult> performQuery(
    NameRepository db, String text, QueryMode mode) async {
  print('performQuery: $text, $mode');
  text = _cleanInputText(text);

  final ky = guessKY(text);
  Future<Iterable<NameData>> results;
  switch (mode) {
    case QueryMode.mei:
      results = db.getResults(text, NamePart.mei, ky);
      break;
    case QueryMode.sei:
      results = db.getResults(text, NamePart.sei, ky);
      break;
    case QueryMode.wildcard:
      results = db.search(text);
      break;
    case QueryMode.person:
      results = getPersonResult(db, text);
      break;
  }

  return QueryResult(
    ky: ky,
    text: text,
    mode: mode,
    results: (await results).toList(),
  );
}

Future<List<NameData>> getPersonResult(NameRepository db, String text) async {
  // TODO: split name up into two parts or something. Use NamePart to distinguish
  // the two data sets.
  return [
    NameData("松本", "まつもと", NamePart.sei),
    NameData("人志", "ひとし", NamePart.mei),
  ];
}

String _cleanInputText(String text) {
  text = text.trim();

  // Strip trailing romaji from the search query, which appears while the user
  // is typing a new kana or kanji via IME.
  if (text.contains(RegExp(
      r'[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]',
      unicode: true))) {
    text = text.replaceAll(RegExp(r'[\u{FF21}-\u{FF5A}]$', unicode: true), '');
  }

  return text;
}
