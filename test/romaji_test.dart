import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/core/services/name_database.dart';

void main() {
  test('romaji apostrophes are used to avoid ambiguity', () {
    // Without apostrophe, could be parsed as こんいちは
    expect(kanaToRomaji("こんにちは"), "kon'nichiha");
    // With apostrophe, could be parsed as あんあ
    expect(kanaToRomaji("あんな"), "an'na");

    expect(romajiToKana("kon'nichiha"), "こんにちは");
    expect(romajiToKana("an'na"), "あんな");
  });
}
