import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/core/services/name_database.dart';

void main() {
  test('romaji apostrophes are used to avoid ambiguity', () {
    expect(kanaToRomaji("こんにちは"), "konnichiha");
    expect(kanaToRomaji("あんな"), "anna");
    expect(kanaToRomaji("そんな"), "sonna");

    // Handle ambiguity
    expect(kanaToRomaji("はんのう"), "hannou");
    expect(kanaToRomaji("はんおう"), "han'ou");

    expect(romajiToKana("kon'nichiha"), "こんにちは");
    expect(romajiToKana("an'na"), "あんな");
  });
}
