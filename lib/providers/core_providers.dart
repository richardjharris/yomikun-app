import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/name_lookup.dart';
import 'package:yomikun/models/query.dart';
import 'package:yomikun/models/query_result.dart';
import 'package:yomikun/services/bookmark_database.dart';
import 'package:yomikun/services/shared_preferences_service.dart';

import '../services/name_database.dart';

// Overridden in main.dart
final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((_) => throw UnimplementedError());

final databaseProvider = Provider((_) => NameDatabase());

final queryResultProvider =
    FutureProvider.family<QueryResult, Query>((ref, query) async {
  final db = ref.read(databaseProvider);
  return performQuery(db, query.text, query.mode);
});

final bookmarkDatabaseProvider = Provider((_) => BookmarkDatabase());
