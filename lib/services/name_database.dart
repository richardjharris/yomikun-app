import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yomikun/models/namedata.dart';

import 'name_repository.dart';

class NameDatabase implements NameRepository {
  Database? _db;

  // TODO locking?
  Future<Database> get database async {
    if (_db != null) {
      return Future.value(_db);
    }
    _db = await _initialize();
    return Future.value(_db);
  }

  /// Initialise the database, requesting permissions.
  static Future<Database> _initialize() async {
    // Copy the database into the documents dir
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "asset_names.db");

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
  /// part of speech.
  @override
  Future<bool> hasPrefix(String prefix, NamePart part, KakiYomi ky) async {
    var db = await database;
    var column = ky.name;
    final result = await db.rawQuery('''
      SELECT 1 FROM names
      WHERE $column LIKE ? || '%' AND part = ?
      LIMIT 1
    ''', [prefix, part.name]);
    return Future.value(result.isNotEmpty);
  }

  /// Returns all results with kaki/yomi equal to the given string, for the
  /// given part of speech.
  @override
  Future<Iterable<NameData>> getResults(
      String query, NamePart part, KakiYomi ky) async {
    var db = await database;
    var column = ky.name;
    final result = await db.rawQuery('''
      SELECT * FROM names
      WHERE $column = ? AND part = ?
    ''', [query, part.name]);

    return Future.value(result.map((row) => NameData.fromMap(row)));
  }

  /// Perform a general database search given the specified query.
  /// Query may contain wildcards */?
  @override
  Future<Iterable<NameData>> search(String query) async {
    // Convert query to SQL like form
    query = query.replaceAll(RegExp(r'[\*＊]', unicode: true), '%');
    query = query.replaceAll(RegExp(r'[\?？]', unicode: true), '_');

    var db = await database;
    final results = await db.query(
      'names',
      where: " kaki LIKE ? OR yomi LIKE ? ",
      whereArgs: [query, query],
      orderBy: 'hits_total DESC',
    );
    return results.map((row) => NameData.fromMap(row));
  }

  /// Returns the data for a specific item, if present
  Future<NameData?> get(String kaki, String yomi, NamePart part) async {
    var db = await database;
    final result = await db.query(
      'names',
      where: " kaki = ? AND yomi = ? AND part = ? ",
      whereArgs: [kaki, yomi, part],
      limit: 1,
    );
    if (result.length == 1) {
      return NameData.fromMap(result.first);
    } else {
      return null;
    }
  }
}
