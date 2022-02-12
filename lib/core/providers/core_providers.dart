import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:yomikun/core/name_lookup.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:yomikun/core/services/name_database.dart';

const kanaKit = KanaKit();

final databaseProvider = Provider((_) => NameDatabase());

final queryResultProvider =
    FutureProvider.family<QueryResult, Query>((ref, query) async {
  final db = ref.read(databaseProvider);
  return performQuery(db, query.text, query.mode);
});

final bookmarkDatabaseProvider =
    ChangeNotifierProvider((_) => BookmarkDatabase());
