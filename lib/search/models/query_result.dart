import 'package:yomikun/core/split.dart';
import 'package:yomikun/search/models.dart';

class QueryResult {
  final String text;
  final QueryMode mode;

  /// Was input interpreted as kaki or yomi
  final KakiYomi? ky;

  /// List of results
  final List<NameData> results;

  /// Error, if relevant
  final String? error;

  /// Split result, used for Person queries.
  final SplitResult? splitResult;

  const QueryResult({
    required this.text,
    required this.mode,
    required this.results,
    this.ky,
    this.error,
    this.splitResult,
  });

  @override
  String toString() {
    return "QueryResult(text: $text, mode: $mode, results: $results, ky: ${ky ?? ''}, error: ${error ?? ''}, splitResult: ${splitResult ?? ''})";
  }

  static QueryResult initialState() {
    return const QueryResult(
      text: '',
      mode: QueryMode.sei,
      results: [],
      ky: KakiYomi.kaki,
      error: null,
      splitResult: null,
    );
  }
}
