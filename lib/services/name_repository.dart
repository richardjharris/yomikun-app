import 'package:yomikun/models/namedata.dart';

abstract class NameRepository {
  /// Returns bool indicating if a name exists (kaki or yomi) for the given
  /// part of speech.
  Future<bool> hasPrefix(String prefix, NamePart part, KakiYomi ky);

  /// Returns all results with kaki/yomi equal to the given string, for the
  /// given part of speech.
  Future<Iterable<NameData>> getResults(
      String query, NamePart part, KakiYomi ky);

  /// Perform a general database search given the specified query.
  /// Query may contain wildcards */?
  Future<Iterable<NameData>> search(String query);
}
