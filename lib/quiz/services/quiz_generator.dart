import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/models/quiz_name_type.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';

/// Generate a new quiz
Future<List<Question>> generateQuiz(QuizSettings settings,
    {required NameDatabase db}) async {
  // Returns most popular kanji w/ most common readings.
  final future = db.getQuizData(
    limit: settings.questionCount * 20,
    offset: (settings.difficulty - 1) * 100,
    partFilter: settings.nameType.toNamePart(),
  );

  final data = (await future).toList()..shuffle();

  return data
      .take(settings.questionCount)
      .map((row) => Question(
            kanji: row.kaki,
            part: row.part,
            readings: row.yomi,
          ))
      .toList();
}
