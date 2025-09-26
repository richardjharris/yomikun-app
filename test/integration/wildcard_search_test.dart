import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/search/models.dart';

/// Test that the wildcard search correctly handles romaji and kana: for kana,
/// the ? and * operators should work on morae rather than letters.
///
/// We test NameDatabase directly, relying on the database in the assets/
/// directory, so this is almost an integration test.

final tests = [
  ...const [
    Test(
      'utsunomi*',
      shouldContain: [
        NameData.sei('宇都宮', 'うつのみや'),
      ],
    ),
    Test('utsunomi?', hasNoResults: true),
    Test(
      'ann?',
      shouldContain: [
        NameData.mei('杏奈', 'あんな'),
        NameData.sei('安野', 'あんの'),
      ],
    ),
    Test(
      'なお？',
      shouldContain: [
        NameData.mei('直樹', 'なおき'),
        NameData.mei('直人', 'なおと'),
        NameData.mei('直子', 'なおこ'),
        NameData.mei('直美', 'なおみ'),
      ],
      message: 'kana ? means one mora',
    ),
    Test(
      'nao?',
      shouldContain: [
        NameData.sei('直江', 'なおえ'),
        NameData.sei('直井', 'なおい'),
      ],
      shouldNotContain: [
        NameData.mei('直美', 'なおみ'),
        NameData.mei('直樹', 'なおき'),
      ],
      message: 'romaji ? means one letter',
    ),
    Test(
      '奈央？',
      shouldContain: [
        NameData.mei('奈央子', 'なおこ'),
      ],
    ),
  ],
  ...['', '*', '?', '*?', '?*', '?*?', ' *', '? ', '？', '＊', '＊＊']
      .map((q) => Test(q, hasNoResults: true, message: 'wildcard only')),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final db = NameDatabase();
  group('wildcard search tests', () {
    for (final t in tests) {
      test(t.name, () async {
        final results = (await db.search(t.query)).toList();
        for (final item in t.shouldContain) {
          expect(results, contains(item));
        }
        for (final item in t.shouldNotContain) {
          expect(results, isNot(contains(item)));
        }
        expect(results.isEmpty, t.hasNoResults);
      });
    }
  });
}

/// Test case for wildcard search test
class Test {
  final String query;
  final List<NameData> shouldContain;
  final List<NameData> shouldNotContain;
  final bool hasNoResults;
  final String? message;

  const Test(
    this.query, {
    this.shouldContain = const [],
    this.shouldNotContain = const [],
    this.hasNoResults = false,
    this.message,
  });

  String get name => '[$query]${message != null ? " ($message)" : ""}';
}
