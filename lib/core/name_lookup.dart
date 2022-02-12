import 'package:yomikun/core/split.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/core/services/name_database.dart';

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
    NameDatabase db, String text) async {
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
    return [QueryMode.person];
  }
}

/// Interpret the provided query string and mode, and return a QueryResult.
/// Providers results that update when the query text/mode changes.
Future<QueryResult> performQuery(
    NameDatabase db, String text, QueryMode mode) async {
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

/// Treat [text] as a person name (optionally split with whitespace) and return
/// possible interpretations of both the first and last name part together.
///
/// [NameData] records will have a [NamePart] of `sei` or `mei` depending on
/// the part they belong to.
///
/// If splitting fails, will return an empty list.
Future<List<NameData>> getPersonResult(NameDatabase db, String text) async {
  final splitResult = await splitKanjiName(db, text);
  if (splitResult == null) {
    return [];
  } else {
    return [
      ...await db.getResults(splitResult.sei, NamePart.sei, KakiYomi.kaki),
      ...await db.getResults(splitResult.mei, NamePart.mei, KakiYomi.kaki),
    ];
  }
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
