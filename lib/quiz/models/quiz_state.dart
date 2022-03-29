import 'package:yomikun/quiz/models/question.dart';

class QuizState {
  final List<Question> questions;
  final int questionIndex;
  final int score;

  QuizState({
    required this.questions,
    this.questionIndex = 0,
    this.score = 0,
  });

  factory QuizState.sample() {
    return QuizState(
      questions: [
        Question(
          text: '田中',
          subtext: 'Surname',
          answers: ['たなか'],
        ),
      ],
    );
  }

  Question currentQuestion() {
    return questions[questionIndex];
  }

  QuizState withAnswerCorrect() {
    return copyWith(
      questionIndex: questionIndex + 1,
      score: score + 1,
    );
  }

  QuizState withAnswerIncorrect() {
    return copyWith(
      questionIndex: questionIndex + 1,
    );
  }

  QuizState copyWith({
    List<Question>? questions,
    int? questionIndex,
    int? score,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      questionIndex: questionIndex ?? this.questionIndex,
      score: score ?? this.score,
    );
  }

  @override
  String toString() =>
      'QuizState(questions: $questions, questionIndex: $questionIndex, score: $score)';
}
