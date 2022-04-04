// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:yomikun/quiz/models/quiz_name_type.dart';

/// Parameters for quiz creation
class QuizSettings {
  /// Number of questions
  final int questionCount;

  /// Optional filter to only given names or surnames
  final QuizNameType nameType;

  /// Difficulty (1-10, 1 = easy, 10 = hard)
  final int difficulty;

  const QuizSettings({
    this.questionCount = 10,
    this.nameType = QuizNameType.both,
    this.difficulty = 3,
  }) : assert(difficulty >= 1 && difficulty <= 10);

  @override
  String toString() =>
      'QuizSettings(questionCount: $questionCount, partFilter: $nameType, difficulty: $difficulty)';

  QuizSettings copyWith({
    int? questionCount,
    QuizNameType? nameType,
    int? difficulty,
  }) {
    return QuizSettings(
      questionCount: questionCount ?? this.questionCount,
      nameType: nameType ?? this.nameType,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionCount': questionCount,
      'nameType': nameType.name,
      'difficulty': difficulty,
    };
  }

  factory QuizSettings.fromMap(Map<String, dynamic> map) {
    return QuizSettings(
      questionCount: map['questionCount'] as int,
      nameType: (map['nameType'] as String).toQuizNameType(),
      difficulty: map['difficulty'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizSettings.fromJson(String source) =>
      QuizSettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
