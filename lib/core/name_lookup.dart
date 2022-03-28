import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
  Iterable<NameData> results;
  SplitResult? splitResult;
  switch (mode) {
    case QueryMode.mei:
      results = await db.getResults(text, NamePart.mei, ky);
      break;
    case QueryMode.sei:
      results = await db.getResults(text, NamePart.sei, ky);
      break;
    case QueryMode.wildcard:
      results = await db.search(text);
      break;
    case QueryMode.person:
      final personResult = await getPersonResult(db, text);
      results = [...personResult.sei, ...personResult.mei];
      splitResult = personResult.splitResult;
      break;
  }

  return QueryResult(
    ky: ky,
    text: text,
    mode: mode,
    results: results.toList(),
    splitResult: splitResult,
  );
}

/// Result of interpreting an input as a person name.
///
/// [sei] and [mei] hold [NameData] objects indicating possible readings of the
/// name components.
/// [splitResult] indicates the result of splitting the name into components,
/// or null if unsuccessful.
class PersonResult {
  final Iterable<NameData> sei;
  final Iterable<NameData> mei;
  final SplitResult? splitResult;

  const PersonResult({
    this.sei = const [],
    this.mei = const [],
    this.splitResult,
  });
}

/// Treat [text] as a person name (optionally split with whitespace) and return
/// possible interpretations of both the first and last name part together.
///
/// It is possible to split even if only one part of the name (sei/mei) is in
/// the database. In this case, the part that is not in the database will have
/// no [NameData] records returned. For example, the name 任天堂 will return:
///
/// ```dart
/// PersonResult(
///  splitResult: SplitResult("任", "天堂"),
///  sei: [NameData.sei("任", "にん"), NameData.sei("任", "じん"), ...]
///  mei: [],
/// );
/// ```
///
/// This indicates that the surname is probably 任 with one of the above readings,
/// while the given name is probably 天堂, but we don't know how to read it.
///
/// If splitting fails, will return an empty [PersonResult] object.
Future<PersonResult> getPersonResult(NameDatabase db, String text) async {
  final splitResult = await splitKanjiName(db, text);
  if (splitResult == null) {
    return const PersonResult();
  } else {
    // Look up all possible readings for the split kanji parts.
    return PersonResult(
      splitResult: splitResult,
      sei: await db.getResults(splitResult.sei, NamePart.sei, KakiYomi.kaki),
      mei: await db.getResults(splitResult.mei, NamePart.mei, KakiYomi.kaki),
    );
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
