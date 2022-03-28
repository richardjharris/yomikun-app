import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/models/settings_models.dart';

void main() {
  test('NameData.sei', () {
    const name = NameData.sei("中村", "なかむら");
    expect(name.kaki, "中村");
    expect(name.yomi, "なかむら");
    expect(name.part, NamePart.sei);

    expect(name.hitsTotal, 0, reason: 'defaults to zero');
    expect(name.key(), "中村|なかむら|sei");
    expect(name.toRouteArgs(), {
      'kaki': '中村',
      'yomi': 'なかむら',
      'part': 'sei',
    });
    expect(NameData.fromRouteArgs(name.toRouteArgs()), name,
        reason: 'round trip conversion');
  });
  test('NameData.mei', () {
    const name = NameData.mei("亮", "りょう");
    expect(name.kaki, "亮");
    expect(name.yomi, "りょう");
    expect(name.part, NamePart.mei);
  });

  test('hit counts', () {
    const name = NameData(
      kaki: '中村',
      yomi: 'なかむら',
      part: NamePart.sei,
      hitsTotal: 100,
      hitsMale: 9,
      hitsFemale: 90,
    );
    expect(name.hitsUnknown, 1);
    expect(name.hitsPseudo, 0, reason: 'defaults to zero');
  });

  test('NameData.formatYomi', () {
    const name = NameData.sei("山崎", "やまざき");
    expect(name.formatYomi(NameFormatPreference.romaji), "yamazaki");
    expect(name.formatYomi(NameFormatPreference.hiragana), "やまざき");
    expect(name.formatYomi(NameFormatPreference.hiraganaBigAccent), "やまさﾞき");

    expect(formatYomiString("たっぷり", NameFormatPreference.hiraganaBigAccent),
        "たっふﾟり");

    expect(name.format(KakiYomi.kaki, NameFormatPreference.romaji), '山崎');
    expect(name.format(KakiYomi.yomi, NameFormatPreference.romaji), 'yamazaki');
  });
}
