enum NamePart { mei, sei, unknown, person }

enum KakiYomi { kaki, yomi }

extension KakiYomiMethods on KakiYomi {
  KakiYomi inverse() {
    return this == KakiYomi.kaki ? KakiYomi.yomi : KakiYomi.kaki;
  }
}

class NameData {
  final String kaki;
  final String yomi;
  final NamePart part;

  /* number of people with this name */
  final int hitsTotal;
  final int hitsMale;
  final int hitsFemale;

  /* number of fictional/pseudonym hits for this name */
  final int hitsPseudo;

  /* gender score between 0 (Male) and 255 (Female) */
  final int genderMlScore;

  const NameData({
    required this.kaki,
    required this.yomi,
    required this.part,
    this.hitsTotal = 0,
    this.hitsMale = 0,
    this.hitsFemale = 0,
    this.hitsPseudo = 0,
    this.genderMlScore = 0,
  });

  String key() {
    return kaki + "|" + yomi + "|" + part.toString();
  }

  int get hitsUnknown => hitsTotal - hitsMale - hitsFemale;

  @override
  String toString() {
    return 'NameData{kaki: $kaki, yomi: $yomi, part: $part, '
        'hitsTotal: $hitsTotal, hitsMale: $hitsMale, hitsFemale: $hitsFemale, '
        'hitsPseudo: $hitsPseudo, genderMlScore: $genderMlScore}';
  }
}
