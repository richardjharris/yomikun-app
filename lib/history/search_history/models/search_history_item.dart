import 'package:hive_flutter/hive_flutter.dart';
import 'package:yomikun/search/models.dart';

part 'search_history_item.g.dart';

@HiveType(typeId: 1)
class SearchHistoryItem {
  @HiveField(0)
  final Query query;
  @HiveField(1)
  final DateTime date;

  SearchHistoryItem({required this.query, required this.date});

  SearchHistoryItem.now(this.query) : date = DateTime.now();
}
