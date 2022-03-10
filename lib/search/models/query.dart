import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yomikun/search/models.dart';

part 'query.g.dart';

@HiveType(typeId: 2)
class Query extends Equatable {
  @HiveField(0)
  final String text;
  @HiveField(1)
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

  static Query fromMap(Map map) {
    return Query(
      map['text'] as String,
      (map['mode'] as String).toQueryMode()!,
    );
  }
}
