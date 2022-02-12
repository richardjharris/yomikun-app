import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/search/models.dart';

/// NamePart values in the same order as stored in SQLite as INT offsets.
/// This is used as SQLite does not support native ENUMs.
const nameParts = [NamePart.unknown, NamePart.sei, NamePart.mei];

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
    }

    return openDatabase(dbPath);
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
}

/// Convert a database part ID to a NamePart.
NamePart _partName(int id) {
  return nameParts[id];
}

/// Convert a NamePart to a database part ID.
int _partId(NamePart part) {
  return nameParts.indexOf(part);
}

/// Convert a kana string to romaji.
String _kanaToRomaji(String kana) {
  return kanaKit.toRomaji(kana);
}

/// Convert a database row to a NameData object.
NameData _toNameData(Map<String, Object?> row) {
  NamePart part = _partName(row['part'] as int);
  String kaki = row['kaki'] as String;
  String yomi = kanaKit.toHiragana(row['yomi'] as String);

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
