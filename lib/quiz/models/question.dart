import 'package:yomikun/core/utilities/kana.dart';

class Question {
  final String text;
  final String subtext;
  final List<String> answers;

  Question({
    required this.text,
    required this.subtext,
    required this.answers,
  });

  bool isCorrectAnswer(String answer) {
    answer = romajiToKana(answer.trim());
    return answers.contains(answer);
  }

  @override
  String toString() =>
      'Question(text: $text, subtext: $subtext, answers: $answers)';
}
