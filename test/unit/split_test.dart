import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/core/split.dart';
import 'package:yomikun/search/models.dart';

class FakeNameDatabase extends NameDatabase {
  static const Map<NamePart, Set<String>> _database = {
    NamePart.sei: {'田中', '橘'},
    NamePart.mei: {
      '太郎',
      '彰',
    },
  };

  @override
  Future<bool> hasExact(String match, NamePart part, KakiYomi ky) async {
    assert(ky == KakiYomi.kaki);
    assert(part == NamePart.mei || part == NamePart.sei);
    return _database[part]!.contains(match);
  }
}

void main() {
  final db = FakeNameDatabase();

  group('split', () {
    test('should split simple name', () async {
      expect(
        await splitKanjiName(db, '田中太郎'),
        SplitResult(sei: '田中', mei: '太郎'),
      );
      expect(
        await splitKanjiName(db, '田中彰'),
        SplitResult(sei: '田中', mei: '彰'),
      );
      expect(
        await splitKanjiName(db, '橘太郎'),
        SplitResult(sei: '橘', mei: '太郎'),
      );
      expect(
        await splitKanjiName(db, '橘彰'),
        SplitResult(sei: '橘', mei: '彰'),
      );
    });
    test('handle unknown first name', () async {
      expect(
        await splitKanjiName(db, '田中絆'),
        SplitResult(sei: '田中', mei: '絆'),
      );
    });
    test('handle unknown surname', () async {
      expect(
        await splitKanjiName(db, '悪山太郎'),
        SplitResult(sei: '悪山', mei: '太郎'),
      );
    });
    test('handle unknown surname and first name', () async {
      expect(
        await splitKanjiName(db, '悪山絆'),
        null,
      );
    });
    test('handle space already there', () async {
      expect(
        await splitKanjiName(db, '田中 太郎'),
        SplitResult(sei: '田中', mei: '太郎'),
      );
      expect(
        await splitKanjiName(db, '悪山 絆'),
        SplitResult(sei: '悪山', mei: '絆'),
      );
      expect(
        await splitKanjiName(db, '悪山　絆'),
        SplitResult(sei: '悪山', mei: '絆'),
      );
      expect(
        await splitKanjiName(db, '悪山　'),
        null,
        reason: 'trailing space',
      );
      expect(
        await splitKanjiName(db, '　悪山'),
        null,
        reason: 'leading space',
      );
    });
  });
}
