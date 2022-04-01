import 'package:yomikun/core/utilities/kana.dart';

class Question {
  final String text;
  final String subtext;
  final List<String> answers;

  const Question({
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'subtext': subtext,
      'answers': answers,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] as String,
      subtext: map['subtext'] as String,
      answers: (map['answers'] as List).cast<String>(),
    );
  }
}
