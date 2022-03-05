import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/search/models.dart';

/// NamePart values in the same order as stored in SQLite as INT offsets.
/// This is used as SQLite does not support native ENUMs.
const namePartsInDatabaseOrder = [
  NamePart.unknown, // 0
  NamePart.sei, // 1
  NamePart.mei, // 2
];

class NameDatabase {
  Database? _db;

  /// Mutex to prevent the database being copied by two coroutines at once.
  static final Lock _dbInitializeLock = Lock();

  Future<Database> get database async {
    // Fast path
    if (_db != null) return _db!;

    // Slow path: use lock to prevent multiple rebuilds
    await _dbInitializeLock.synchronized(() async {
      _db ??= await _initialize();
    });

    return _db!;
  }

  /// Initialise the database, requesting permissions.
  static Future _initialize() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "asset_names.db");
    // Copy the database into the documents dir

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'names.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(dbPath).writeAsBytes(bytes);
    } else {
      // TODO check getVersion(db) against current version.
      // Need to write the version to a file.
    }

    return await openDatabase(dbPath);
  }

  /// Returns database version
  static Future<int> getVersion(Database db) async {
    return Sqflite.firstIntValue(await db.rawQuery('PRAGMA user_version'))!;
  }

  /// Returns bool indicating if a name exists (kaki or yomi) for the given
  /// part of speech, starting with [prefix].
  Future<bool> hasPrefix(String prefix, NamePart part, KakiYomi ky) async {
    var db = await database;
    var column = ky.name;

    if (ky == KakiYomi.yomi) {
      prefix = _kanaToRomaji(prefix);
    }

    final result = await db.rawQuery('''
      SELECT 1 FROM names
      WHERE $column LIKE ? || '%' AND part = ?
      LIMIT 1
    ''', [prefix, _partId(part)]);
    return Future.value(result.isNotEmpty);
  }

  /// Returns bool indicating if a name exists (kaki or yomi) for the given
  /// part of speech, precisely equal to [match].
  Future<bool> hasExact(String match, NamePart part, KakiYomi ky) async {
    var db = await database;
    var column = ky.name;

    if (ky == KakiYomi.yomi) {
      match = _kanaToRomaji(match);
    }

    final result = await db.rawQuery('''
      SELECT 1 FROM names
      WHERE $column = ? AND part = ?
      LIMIT 1
    ''', [match, _partId(part)]);
    return Future.value(result.isNotEmpty);
  }

  /// Returns all results with kaki/yomi equal to the given string, for the
  /// given part of speech.
  Future<Iterable<NameData>> getResults(
      String query, NamePart part, KakiYomi ky) async {
    var db = await database;
    var column = ky.name;

    if (ky == KakiYomi.yomi) {
      query = _kanaToRomaji(query);
    }

    final result = await db.rawQuery('''
      SELECT * FROM names
      WHERE $column = ? AND part = ?
    ''', [query, _partId(part)]);

    return result.map(_toNameData);
  }

  /// Perform a general database search given the specified query.
  /// Query may contain wildcards */?
  Future<Iterable<NameData>> search(String query) async {
    // Convert query to SQL like form
    query = query.replaceAll(RegExp(r'[\*＊]', unicode: true), '%');
    query = query.replaceAll(RegExp(r'[\?？]', unicode: true), '_');

    String romaji = _kanaToRomaji(query);

    var db = await database;
    final results = await db.query(
      'names',
      where: " kaki LIKE ? OR yomi LIKE ? ",
      whereArgs: [romaji, query],
      orderBy: 'hits_total DESC',
    );
    return results.map(_toNameData);
  }

  /// Returns the data for a specific item, if present
  Future<NameData?> get(String kaki, String yomi, NamePart part) async {
    var db = await database;

    yomi = _kanaToRomaji(yomi);

    final result = await db.query(
      'names',
      where: " kaki = ? AND yomi = ? AND part = ? ",
      whereArgs: [kaki, yomi, _partId(part)],
      limit: 1,
    );
    if (result.length == 1) {
      return _toNameData(result.first);
    } else {
      return null;
    }
  }

  /// Returns most popular names (ordered by hits).
  Future<List<NameData>> getMostPopular(NamePart part, {int limit = 10}) async {
    var db = await database;

    final result = await db.rawQuery('''
      SELECT * FROM names
      WHERE part = ?
      ORDER BY hits_total DESC
      LIMIT ?
    ''', [_partId(part), limit]);

    return result.map(_toNameData).toList();
  }

  /// Returns most popular kanji or kana forms of names, with aggregated counts.
  ///
  /// Results are a list (most popular first) of kanji|kana -> total hits.
  // TODO(rjh) % 'share' might be useful
  Future<List<MapEntry<String, int>>> getMostPopularKY(
      NamePart part, KakiYomi ky,
      {int limit = 10}) async {
    var db = await database;

    final field = ky.name;

    var result = await db.rawQuery('''
      SELECT $field, SUM(hits_total) AS hits
      FROM names
      WHERE part = ?
      GROUP BY $field
      ORDER BY hits DESC
      LIMIT ?
    ''', [_partId(part), limit]);

    return result.map((row) {
      String kakiOrYomi = row[field] as String;
      if (ky == KakiYomi.yomi) {
        kakiOrYomi = _romajiToKana(kakiOrYomi);
      }
      return MapEntry(kakiOrYomi, row['hits'] as int);
    }).toList();
  }

  /// Returns kanji stat information, ordered by female ratio ascending.
  Future<List<KanjiStats>> getKanjiByFemaleRatio() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT kanji, hits_total, female_ratio
      FROM kanji_stats
      WHERE gender = 'A'
      ORDER BY female_ratio
    ''');

    return result.map((row) {
      return KanjiStats(
        NamePart.mei,
        row['kanji'] as String,
        GenderFilter.all,
        row['hits_total'] as int,
        (row['female_ratio'] as int) / 255.0,
      );
    }).toList();
  }

  String _genderCode(GenderFilter gender) {
    switch (gender) {
      case GenderFilter.all:
        return 'A';
      case GenderFilter.female:
        return 'F';
      case GenderFilter.male:
        return 'M';
    }
  }

  /// Returns a list of the most common kanji used in names.
  // TODO(rjh) return a List<Map> or similar.
  Future<List<KanjiStats>> getMostCommonKanji(NamePart part,
      [GenderFilter gender = GenderFilter.all, int limit = 500]) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT kanji, hits_total
      FROM kanji_stats
      WHERE part = ?
        AND gender = ?
        AND hits_total > 0
      ORDER BY hits_total DESC
      LIMIT $limit
    ''', [_partId(part), _genderCode(gender)]);

    return result.map((row) {
      return KanjiStats(
        part,
        row['kanji'] as String,
        gender,
        row['hits_total'] as int,
        0.0, // not applicable to result
      );
    }).toList();
  }

  /// Returns a list of the unisex first names.
  Future<List<NameData>> getUnisexFirstNames() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT * FROM names
      WHERE part = ?
        AND hits_total > 25
        AND ml_score >= 20 AND ml_score <= 230
      ORDER BY hits_total DESC
      LIMIT 500
    ''', [_partId(NamePart.mei)]);

    return result.map(_toNameData).toList();
  }
}

class KanjiStats {
  final NamePart part;
  final String kanji;
  final GenderFilter gender;
  final int hitsTotal;
  final double femaleRatio;

  KanjiStats(
      this.part, this.kanji, this.gender, this.hitsTotal, this.femaleRatio);
}

/// Convert a database part ID to a NamePart.
NamePart _partName(int id) {
  return namePartsInDatabaseOrder[id];
}

/// Convert a NamePart to a database part ID.
int _partId(NamePart part) {
  return namePartsInDatabaseOrder.indexOf(part);
}

/// Convert a kana string to romaji.
String _kanaToRomaji(String kana) {
  return kanaKit.toRomaji(kana);
}

/// Convert a romaji string to kana.
String _romajiToKana(String romaji) {
  return kanaKit.toHiragana(romaji);
}

/// Convert a database row to a NameData object.
NameData _toNameData(Map<String, Object?> row) {
  NamePart part = _partName(row['part'] as int);
  String kaki = row['kaki'] as String;
  String yomi = _romajiToKana(row['yomi'] as String);

  return NameData(
    kaki: kaki,
    yomi: yomi,
    part: part,
    hitsTotal: row['hits_total'] as int,
    hitsMale: row['hits_male'] as int,
    hitsFemale: row['hits_female'] as int,
    hitsPseudo: row['hits_pseudo'] as int,
    genderMlScore: row['ml_score'] as int,
  );
}
