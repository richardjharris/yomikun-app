import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/search/models.dart';

void main() {
  test('KakiYomi.inverse', () {
    expect(KakiYomi.kaki.inverse(), KakiYomi.yomi);
    expect(KakiYomi.yomi.inverse(), KakiYomi.kaki);
  });
}
