import 'package:yomikun/core/utilities/kana.dart';
import 'package:yomikun/search/models.dart';

class Question {
  final String kanji;
  final NamePart part;
  final List<String> readings;

  const Question({
    required this.kanji,
    required this.part,
    required this.readings,
  });

  /// Includes [readings] plus variants which allow the user to type 'n' without
  /// doubling it or adding an apostrophe, e.g. けんいち should accept kenichi,
  /// kennichi and ken'ichi.
  Set<String> get passableReadings => {
        ...readings,
        ...readings
            .map(kanaToRomaji)
            .map((kana) => kana.replaceAll("n'", "n"))
            .map(romajiToKana),
      };

  bool isCorrectAnswer(String answer) {
    answer = answer.trim().toLowerCase();
    answer = answer.replaceAll("nn", "n'");

    final fromRomaji = romajiToKana(answer);
    if (fromRomaji != answer) {
      // Was converted from romaji, allow n variations
      return passableReadings.contains(fromRomaji);
    } else {
      return readings.contains(answer);
    }
  }

  @override
  String toString() =>
      'Question(kanji: $kanji, part: ${part.name}, readings: $readings)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kanji': kanji,
      'part': part.name.toString(),
      'readings': readings,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      kanji: map['kanji'] as String,
      part: (map['part'] as String).toNamePart()!,
      readings: (map['readings'] as List).cast<String>(),
    );
  }
}
