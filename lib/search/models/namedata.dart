import 'package:equatable/equatable.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/utilities/dakuten.dart';
import 'package:yomikun/search/models/kaki_yomi.dart';
import 'package:yomikun/search/models/name_part.dart';
import 'package:yomikun/settings/models/settings_models.dart';

class NameData extends Equatable {
  final String kaki;
  final String yomi;
  final NamePart part;

  /* number of people with this name */
  final int hitsTotal;
  final int hitsMale;
  final int hitsFemale;

  /* number of fictional/pseudonym hits for this name */
  final int hitsPseudo;

  /* score between 0.0 (all Male) and 1.0 (all Female) */
  final double femaleRatio;

  const NameData({
    required this.kaki,
    required this.yomi,
    required this.part,
    this.hitsTotal = 0,
    this.hitsMale = 0,
    this.hitsFemale = 0,
    this.hitsPseudo = 0,
    this.femaleRatio = 0,
  });

  const NameData.sei(String kaki, String yomi)
      : this(kaki: kaki, yomi: yomi, part: NamePart.sei);

  const NameData.mei(String kaki, String yomi)
      : this(kaki: kaki, yomi: yomi, part: NamePart.mei);

  @override
  List<Object> get props => [kaki, yomi, part];

  String key() {
    return kaki + "|" + yomi + "|" + part.toString();
  }

  String format(KakiYomi ky, NameFormatPreference pref) {
    return ky == KakiYomi.kaki ? kaki : formatYomi(pref);
  }

  String formatYomi(NameFormatPreference pref) {
    return formatYomiString(yomi, pref);
  }

  int get hitsUnknown => hitsTotal - hitsMale - hitsFemale;

  @override
  String toString() {
    return 'NameData{kaki: $kaki, yomi: $yomi, part: $part, '
        'hitsTotal: $hitsTotal, hitsMale: $hitsMale, hitsFemale: $hitsFemale, '
        'hitsPseudo: $hitsPseudo, femaleRatio: ${femaleRatio.toStringAsFixed(2)}}';
  }

  Map<String, dynamic> toRouteArgs() {
    return {
      'kaki': kaki,
      'yomi': yomi,
      'part': part.name.toString(),
    };
  }
}

String formatYomiString(String name, NameFormatPreference pref) {
  switch (pref) {
    case NameFormatPreference.romaji:
      return kanaKit.toRomaji(name);
    case NameFormatPreference.hiragana:
      return name;
    case NameFormatPreference.hiraganaBigAccent:
      return expandDakuten(name);
  }
}
