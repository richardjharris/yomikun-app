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

  bool isCorrectAnswer(String answer) {
    answer = romajiToKana(answer.trim());
    return readings.contains(answer);
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
