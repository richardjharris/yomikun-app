import 'dart:convert';

import 'package:yomikun/quiz/models/question.dart';

/// Whether we are showing the question or answer part of a quiz question.
enum CurrentQuestionState {
  question,
  answer,
}

/// Holds quiz data and current progress.
class QuizState {
  final List<Question> questions;

  /// Index of current question (0-based).
  ///
  /// A value exceeding the count of [questions] indicates that the quiz is
  /// finished.
  final int questionIndex;

  /// Number of correct questions so far.
  final int score;

  /// For the current question, whether we are showing the correct answer
  /// to the user
  final CurrentQuestionState currentQuestionState;

  /// For the current question, the user's raw input string.
  final String currentUserAnswer;

  const QuizState({
    required this.questions,
    this.questionIndex = 0,
    this.score = 0,
    this.currentQuestionState = CurrentQuestionState.question,
    this.currentUserAnswer = '',
  }) : assert(questions.length > 0);

  factory QuizState.sample() {
    return QuizState(
      questions: [
        const Question(
          text: '田中',
          subtext: 'Surname',
          answers: ['たなか'],
        ),
      ],
    );
  }

  factory QuizState.sampleTwo() {
    return QuizState(
      questions: [
        const Question(
          text: '木村',
          subtext: 'Surname',
          answers: ['きむら'],
        ),
        const Question(
          text: '大野',
          subtext: 'Surname',
          answers: ['おおの'],
        ),
      ],
    );
  }

  Question get currentQuestion => questions[questionIndex];

  int get questionCount => questions.length;

  bool get finished => questionIndex >= questionCount;

  // Indicate question is done, even if we haven't moved on to the next
  // one yet.
  int get questionsDone => questionIndex + (showingAnswer ? 1 : 0);

  double get progressRatio => questionsDone / questionCount;

  bool get showingQuestion =>
      currentQuestionState == CurrentQuestionState.question;
  bool get showingAnswer => currentQuestionState == CurrentQuestionState.answer;

  QuizState answer(bool correct) {
    return copyWith(
      score: score + (correct ? 1 : 0),
      currentQuestionState: CurrentQuestionState.answer,
    );
  }

  QuizState nextQuestion() {
    return copyWith(
      questionIndex: questionIndex + 1,
      currentQuestionState: CurrentQuestionState.question,
    );
  }

  QuizState copyWith({
    List<Question>? questions,
    int? questionIndex,
    int? score,
    CurrentQuestionState? currentQuestionState,
    String? currentUserAnswer,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      questionIndex: questionIndex ?? this.questionIndex,
      score: score ?? this.score,
      currentQuestionState: currentQuestionState ?? this.currentQuestionState,
      currentUserAnswer: currentUserAnswer ?? this.currentUserAnswer,
    );
  }

  @override
  String toString() {
    return 'QuizState(questions: $questions, questionIndex: $questionIndex, score: $score, currentQuestionState: $currentQuestionState, currentUserAnswer: $currentUserAnswer)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questions': questions.map((x) => x.toMap()).toList(),
      'questionIndex': questionIndex,
      'score': score,
      'currentQuestionState': currentQuestionState.name.toString(),
      'currentUserAnswer': currentUserAnswer,
    };
  }

  factory QuizState.fromMap(Map<String, dynamic> map) {
    return QuizState(
      questions: (map['questions'] as List<dynamic>)
          .map((x) => Question.fromMap(x))
          .toList(),
      questionIndex: map['questionIndex'] as int,
      score: map['score'] as int,
      currentQuestionState: CurrentQuestionState.values
          .firstWhere((state) => state.name == map['currentQuestionState']),
      currentUserAnswer: map['currentUserAnswer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizState.fromJson(String source) =>
      QuizState.fromMap(json.decode(source) as Map<String, dynamic>);
}
