import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/models/quiz_name_type.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';

/// Generate a new quiz
Future<List<Question>> generateQuiz({
  required NameDatabase db,
  required QuizSettings settings,
}) async {
  // Collect a large sample of Question objects to sample the quiz from.
  // For QuizNameType.both, we sample sei and mei separately, otherwise the more
  // common (by hit count) sei type tends to dominate.
  final List<Question> deck = [];
  for (final part in settings.nameType.toNameParts()) {
    deck.addAll(await db.getQuizData(part, settings.difficulty));
  }

  deck.shuffle();
  return deck.take(settings.questionCount).toList();
}
