import 'package:riverpod/riverpod.dart';
import 'package:yomikun/history/search_history/services/search_history_service.dart';

final searchHistoryServiceProvider = Provider((_) => SearchHistoryService());

final searchHistoryListProvider = StreamProvider((ref) {
  final service = ref.read(searchHistoryServiceProvider);
  return service.watchHistory();
});
