import 'package:equatable/equatable.dart';
import 'package:yomikun/models/namedata.dart';

enum QueryMode { mei, sei, person, wildcard }

class Query extends Equatable {
  final String text;
  final QueryMode mode;

  const Query(this.text, this.mode);

  @override
  List<Object> get props => [text, mode];

  @override
  bool get stringify => true;
}

class QueryResult {
  final String text;
  final QueryMode mode;

  /// Was input interpreted as kaki or yomi
  final KakiYomi? ky;

  /// List of results
  final List<NameData> results;

  /// Error, if relevant
  final String? error;

  const QueryResult({
    required this.text,
    required this.mode,
    required this.results,
    this.ky,
    this.error,
  });

  @override
  String toString() {
    return "QueryResult(text: $text, mode: $mode, results: $results, ky: ${ky ?? ''}, error: ${error ?? ''})";
  }

  static QueryResult initialState() {
    return const QueryResult(
      text: '',
      mode: QueryMode.sei,
      results: [],
      ky: KakiYomi.kaki,
      error: null,
    );
  }
}
