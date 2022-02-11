import 'package:equatable/equatable.dart';
import 'package:yomikun/search/models.dart';

class Query extends Equatable {
  final String text;
  final QueryMode mode;

  const Query(this.text, this.mode);

  const Query.mei(String text) : this(text, QueryMode.mei);
  const Query.sei(String text) : this(text, QueryMode.sei);

  @override
  List<Object> get props => [text, mode];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'mode': mode.name,
    };
  }

  static Query fromMap(Map<String, dynamic> map) {
    return Query(
      map['text'] as String,
      QueryMode.values.firstWhere((e) => e.name == map['mode']),
    );
  }
}
