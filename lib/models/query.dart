import 'package:yomikun/models/namedata.dart';

class Query {
  final String query;
  final String mode;
  final NamePart? part;
  final KakiYomi? ky;
  final List<NameData> results;

  Query(
      {required this.query,
      required this.mode,
      this.part,
      this.ky,
      required this.results});
}
