// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  /// For each question, whether or not it was answered correctly.
  final List<bool> scores;

  /// For the current question, whether we are showing the correct answer
  /// to the user
  final CurrentQuestionState currentQuestionState;

  /// For the current question, the user's raw input string.
  final String currentUserAnswer;

  const QuizState({
    required this.questions,
    this.questionIndex = 0,
    this.scores = const [],
    this.currentQuestionState = CurrentQuestionState.question,
    this.currentUserAnswer = '',
  }) : assert(questions.length > 0);

  /// Index of currently displayed question, starting from 0.
  Question get currentQuestion => questions[questionIndex];

  /// Total number of questions.
  int get questionCount => questions.length;

  /// Number of correct answers.
  int get score => scores.where((s) => s).length;

  /// True if all questions have been completed or skipped.
  bool get finished => questionIndex >= questionCount;

  /// True if the user has a perfect score and the quiz is complete.
  bool get gotPerfectScore => score == questionCount && finished;

  /// True if the quiz is displaying the final question.
  bool get isLastQuestion => questionIndex == questionCount - 1;

  /// Count of questions done. This includes the currently displayed question
  /// IF the user has submitted an answer.
  int get questionsDone => questionIndex + (showingAnswer ? 1 : 0);

  /// Current progress as a percentage (0.0-1.0)
  double get progressRatio => questionsDone / questionCount;

  /// True if the front side of a question card is displayed (i.e. user is
  /// answering)
  bool get showingQuestion =>
      currentQuestionState == CurrentQuestionState.question;

  /// True if the back side of a question card is displayed (i.e. user has
  /// answered).
  bool get showingAnswer => currentQuestionState == CurrentQuestionState.answer;

  /// Returns a new state after the user has submitted [answer] (use an empty
  /// string to skip) and whether the answer was [correct].
  QuizState answer(String answer, bool correct) {
    return copyWith(
      scores: [...scores, correct],
      currentQuestionState: CurrentQuestionState.answer,
      currentUserAnswer: answer,
    );
  }

  /// Returns a new state after the user has moved on to the next question.
  QuizState nextQuestion() {
    return copyWith(
      questionIndex: questionIndex + 1,
      currentQuestionState: CurrentQuestionState.question,
    );
  }

  QuizState copyWith({
    List<Question>? questions,
    int? questionIndex,
    List<bool>? scores,
    CurrentQuestionState? currentQuestionState,
    String? currentUserAnswer,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      questionIndex: questionIndex ?? this.questionIndex,
      scores: scores ?? this.scores,
      currentQuestionState: currentQuestionState ?? this.currentQuestionState,
      currentUserAnswer: currentUserAnswer ?? this.currentUserAnswer,
    );
  }

  @override
  String toString() {
    return 'QuizState(questions: $questions, questionIndex: $questionIndex, scores: $scores, currentQuestionState: $currentQuestionState, currentUserAnswer: $currentUserAnswer)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questions': questions.map((x) => x.toMap()).toList(),
      'questionIndex': questionIndex,
      'scores': scores,
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
      scores: (map['scores'] as List<dynamic>).cast<bool>(),
      currentQuestionState: CurrentQuestionState.values
          .firstWhere((state) => state.name == map['currentQuestionState']),
      currentUserAnswer: map['currentUserAnswer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizState.fromJson(String source) =>
      QuizState.fromMap(json.decode(source) as Map<String, dynamic>);
}
