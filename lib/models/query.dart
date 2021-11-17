import 'package:yomikun/models/namedata.dart';
import 'package:yomikun/models/query_mode.dart';

class Query {
  final String query;
  final QueryMode mode;
  final NamePart? part;
  final KakiYomi? ky;
  final List<NameData> results;

  // Fallback result as we found no results using the original query mode
  final bool isFallback;

  Query(
      {required this.query,
      required this.mode,
      this.part,
      this.ky,
      required this.results,
      this.isFallback = false});
}
