import 'package:flutter/material.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/widgets/question_flip_card.dart';
import 'package:yomikun/quiz/widgets/question_page/answer_field.dart';

/// Widget that displays a single question and prompts for the answer, then
/// shows the correct answer.
class QuestionPage extends StatefulWidget {
  /// The question to display
  final Question question;

  /// Invoked when the question has been answered or skipped. The boolean
  /// indicates if the answer was correct.
  final ValueChanged<bool> onFinish;

  const QuestionPage({
    Key? key,
    required this.question,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

enum QuestionFlipCardState {
  front,
  flipping,
  back,
}

class _QuestionPageState extends State<QuestionPage> {
  late TextEditingController answerController;
  late FocusNode focusNode;
  late QuestionFlipCardState flipCardState;
  late bool? wasCorrect;

  static const flipDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    flipCardState = QuestionFlipCardState.front;
    answerController = TextEditingController();
    focusNode = FocusNode();
    wasCorrect = null;
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

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          QuestionFlipCard(
            question: widget.question,
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
          Row(
            children: [
              if (showNextButton)
                ElevatedButton(
                    onPressed: _nextQuestion, child: const Text('Next')),
              if (!showNextButton) ...[
                TextButton(
                    child: const Text('Clear'),
                    onPressed: disableButtons ? null : _clearAnswer),
                TextButton(
                    child: const Text('Skip'),
                    onPressed: disableButtons ? null : _skipQuestion),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: answerController,
                  builder: (context, answerValue, _) => ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: disableButtons || answerValue.text.isEmpty
                          ? null
                          : _submitAnswer),
                )
              ],
            ]
                .map((e) => Expanded(child: SizedBox(height: 50, child: e)))
                .toList(),
          ),
        ],
      ),
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
    setState(() {
      wasCorrect = widget.question.isCorrectAnswer(answerController.text);
    });
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
    widget.onFinish(wasCorrect!);
  }
}
