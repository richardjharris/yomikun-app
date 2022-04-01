import 'package:flutter/material.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/quiz/widgets/question_flip_card.dart';
import 'package:yomikun/quiz/widgets/question_page/answer_field.dart';

/// Widget that displays a single question and prompts for the answer, then
/// shows the correct answer.
class QuestionPanel extends StatefulWidget {
  final QuizState quiz;

  /// Called when user submits an answer
  final Function(String) onAnswer;

  /// Called when user moves to the next question
  final VoidCallback onNextQuestion;

  const QuestionPanel({
    Key? key,
    required this.quiz,
    required this.onAnswer,
    required this.onNextQuestion,
  }) : super(key: key);

  @override
  State<QuestionPanel> createState() => _QuestionPanelState();
}

enum QuestionFlipCardState {
  front,
  flipping,
  back,
}

class _QuestionPanelState extends State<QuestionPanel> {
  late TextEditingController answerController;
  late FocusNode focusNode;
  late QuestionFlipCardState flipCardState;
  late bool? wasCorrect;

  static const flipDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    final quiz = widget.quiz;
    final question = quiz.currentQuestion;

    flipCardState = quiz.showingQuestion
        ? flipCardState = QuestionFlipCardState.front
        : flipCardState = QuestionFlipCardState.back;

    wasCorrect = null;
    if (quiz.showingAnswer && quiz.currentUserAnswer.isNotEmpty) {
      wasCorrect = question.isCorrectAnswer(quiz.currentUserAnswer);
    }

    answerController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    answerController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[RJH] flipCardState = $flipCardState');
    final disableButtons = flipCardState != QuestionFlipCardState.front;
    final showNextButton = flipCardState == QuestionFlipCardState.back;

    return Column(
      children: [
        QuestionFlipCard(
          question: widget.quiz.currentQuestion,
          showCardFront: flipCardState == QuestionFlipCardState.front,
          flipDuration: flipDuration,
          onFlipCompleted: _onFlipCompleted,
        ),
        const Spacer(),
        AnswerField(
          controller: answerController,
          focusNode: focusNode,
          onSubmitted: disableButtons ? null : _submitAnswer,
          wasCorrect: wasCorrect,
        ),
        const SizedBox(height: 15),
        if (showNextButton)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: _nextQuestion, child: const Text('Next')),
          ),
        if (!showNextButton)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: answerController,
            builder: (context, value, child) => Row(
              children: [
                TextButton(
                  child: const Text('Clear'),
                  onPressed: disableButtons || value.text.isEmpty
                      ? null
                      : _clearAnswer,
                ),
                TextButton(
                    child: const Text('Skip'),
                    onPressed: disableButtons ? null : _skipQuestion),
                ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: disableButtons || value.text.isEmpty
                        ? null
                        : _submitAnswer),
              ]
                  .map((e) => Expanded(child: SizedBox(height: 50, child: e)))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _clearAnswer() {
    answerController.clear();
    focusNode.requestFocus();
  }

  void _skipQuestion() {
    // set an empty answer to indicate we skipped the question.
    answerController.text = '';
    _flipCard();
  }

  void _submitAnswer() {
    debugPrint('[RJH _submitAnswer (${answerController.text})]');
    widget.onAnswer(answerController.text);
    _flipCard();
  }

  void _flipCard() {
    debugPrint('[RJH] flipCard');
    setState(() {
      flipCardState = QuestionFlipCardState.flipping;
    });
  }

  void _onFlipCompleted() {
    if (flipCardState != QuestionFlipCardState.flipping) {
      // the callback can be triggered during hot reload even when no flip
      // has taken place: ignore
      return;
    }

    setState(() {
      flipCardState = QuestionFlipCardState.back;
    });
  }

  void _nextQuestion() {
    widget.onNextQuestion();
  }
}
