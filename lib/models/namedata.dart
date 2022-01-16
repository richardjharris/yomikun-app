import 'package:flutter/material.dart';

enum NamePart { mei, sei, unknown, person }

enum KakiYomi { kaki, yomi }

class NameData {
  String kaki;
  String yomi;
  NamePart part = NamePart.unknown;

  /* number of people with this name */
  int hitsTotal = 0;

  int hitsMale = 0;
  int hitsFemale = 0;
  int hitsUnknown = 0;
  int hitsPseudo = 0;
  double genderMlScore = 0.0;

  bool isTop5k = false;
  int population = 0;

  NameData(this.kaki, this.yomi, this.part);

  NameData.sei(this.kaki, this.yomi) : part = NamePart.sei;

  NameData.mei(this.kaki, this.yomi) : part = NamePart.mei;

  ValueKey<String> key() {
    return ValueKey(kaki + "|" + yomi + "|" + part.toString());
  }

  setHits(int male, int female, int unknown) {
    hitsMale = male;
    hitsFemale = female;
    hitsUnknown = unknown;
    hitsTotal = male + female + unknown;
  }

  setTotalHits(int hits) {
    hitsTotal = hits;
  }

  setGenderScore(double score) {
    genderMlScore = score;
  }

  NameData.fromMap(Map<String, dynamic> json)
      : kaki = json['kaki'],
        yomi = json['yomi'],
        part = _partToEnum(json['part']),
        hitsMale = json['hits_male'],
        hitsFemale = json['hits_female'],
        hitsUnknown = json['hits_unknown'],
        hitsPseudo = json['hits_pseudo'],
        hitsTotal = json['hits_total'],
        genderMlScore = json['ml_score'],
        isTop5k = json.containsKey('is_top5k') ? json['is_top5k'] : false,
        population = json.containsKey('population') ? json['population'] : 0;

  static NamePart _partToEnum(String part) {
    switch (part) {
      case 'mei':
        return NamePart.mei;
      case 'sei':
        return NamePart.sei;
      default:
        return NamePart.unknown;
    }
  }

  @override
  String toString() {
    return 'NameData{kaki: $kaki, yomi: $yomi, part: $part, hitsTotal: $hitsTotal, hitsMale: $hitsMale, hitsFemale: $hitsFemale, hitsUnknown: $hitsUnknown, hitsPseudo: $hitsPseudo, genderMlScore: $genderMlScore, isTop5k: $isTop5k, population: $population}';
  }
}
