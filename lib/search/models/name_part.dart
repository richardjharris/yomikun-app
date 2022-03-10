import 'package:yomikun/search/models/query_mode.dart';

enum NamePart { mei, sei, unknown, person }

extension NamePartExtension on String {
  NamePart? toNamePart() {
    return NamePart.values.firstWhere((e) => e.name == this);
  }
}

extension ToQueryModeExtension on NamePart {
  QueryMode? toQueryMode() {
    switch (this) {
      case NamePart.mei:
        return QueryMode.mei;
      case NamePart.sei:
        return QueryMode.sei;
      case NamePart.person:
        return QueryMode.person;
      default:
        return null;
    }
  }
}
