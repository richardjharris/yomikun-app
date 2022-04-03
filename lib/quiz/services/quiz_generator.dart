import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/quiz/models/question.dart';

/// Generate a new quiz
Future<List<Question>> generateQuiz({
  required NameDatabase db,
  int numQuestions = 10,
}) async {
  // Returns most popular kanji w/ most common readings.
  final data = (await db.getQuizData()).toList();
  data.shuffle();

  return data
      .take(numQuestions)
      .map((row) => Question(
            kanji: row.kaki,
            part: row.part,
            readings: row.yomi,
          ))
      .toList();
}
