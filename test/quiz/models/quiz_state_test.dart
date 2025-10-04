import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/search/models.dart';

void main() {
  test('QuizState', () {
    final quiz = QuizState(
      questions: [
        const Question(
          kanji: '田中',
          part: NamePart.sei,
          readings: ['たなか'],
        ),
      ],
    );
    expect(quiz.currentQuestion.kanji, '田中');
    expect(quiz.currentQuestionState, CurrentQuestionState.question);
    expect(quiz.currentUserAnswer, '');
    expect(quiz.showingAnswer, false);
    expect(quiz.isShowingQuestion, true);
    expect(quiz.score, 0);
    expect(quiz.finished, false);
    expect(quiz.progressRatio, 0);

    final correct = quiz.answer('たなか', true);
    expect(correct.currentQuestionState, CurrentQuestionState.answer);
    expect(correct.currentUserAnswer, 'たなか');
    expect(correct.score, 1);
    expect(correct.progressRatio, 1.0);

    final wrong = quiz.answer('', false);
    expect(wrong.currentQuestionState, CurrentQuestionState.answer);
    expect(wrong.score, 0);
    expect(wrong.progressRatio, 1.0);
  });
}
